USE [LigneEnsacheuse ]
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateCycleProduction]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_UpdateCycleProduction]
    @Cycle DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -------------------------------------------------------------------------
        -- Declare variables for aggregations and calculations
        -------------------------------------------------------------------------
        DECLARE @N_Total_Arrets_Planifier    TINYINT;
        DECLARE @SumPlanifier_sec             INT;  -- total seconds from Arrets_Planifier
        DECLARE @N_Total_Arrets_Non_Planifier TINYINT;
        DECLARE @SumNonPlanifier_sec          INT;  -- total seconds from Arrets_Non_Planifier

        -- Variables for calculated durations (in seconds and milliseconds)
        DECLARE @TempsRequis_sec              INT;
        DECLARE @TempsBrut_sec                INT;  
        DECLARE @TempsBrut_ms                 INT;
        
        DECLARE @N_Sacs_Total_Produit         SMALLINT;
        DECLARE @N_Sacs_Non_Conforme          SMALLINT;
        
        -------------------------------------------------------------------------
        -- New variable for CadenceReel_s_Sac calculation (in seconds per sack)
        -------------------------------------------------------------------------
        DECLARE @CadenceReel_Sac_sec          DECIMAL(10,2);
        
        DECLARE @EcartCadence_ms              INT;
        DECLARE @Som_Temps_Ecart_Cadence_ms   INT;
        DECLARE @TempsNet_TDT_ms              INT;
        DECLARE @Som_Temps_Production_Non_Qualite_ms INT;
        DECLARE @TempsUtile_ms                INT;
        
        -- Fixed constants: 16:00:00 in seconds and 2.400 seconds in milliseconds.
        DECLARE @Const_TempsRequis_sec INT = 16 * 3600;    -- 57600 seconds
        DECLARE @Const_EcartCadence_ms INT = 2400;           -- 2400 ms
        
        -- Declare the error message variable only once.
        DECLARE @ErrMsg NVARCHAR(400);

        -------------------------------------------------------------------------
        -- Retrieve aggregated data from Arrets_Planifier for the given Cycle
        -------------------------------------------------------------------------
        SELECT  
            @N_Total_Arrets_Planifier = MAX(N_Arret_Planifier),
            @SumPlanifier_sec = ISNULL(SUM(DATEDIFF(SECOND, '00:00:00', Duree_Arret_Planifier)), 0)
        FROM Arrets_Planifier
        WHERE Cycle = @Cycle;
        
        -------------------------------------------------------------------------
        -- Retrieve aggregated data from Arrets_Non_Planifier for the given Cycle
        -------------------------------------------------------------------------
        SELECT  
            @N_Total_Arrets_Non_Planifier = MAX(N_Arret),
            @SumNonPlanifier_sec = ISNULL(SUM(DATEDIFF(SECOND, '00:00:00', Duree_Arret)), 0)
        FROM Arrets_Non_Planifier
        WHERE Cycle = @Cycle;
        
        -------------------------------------------------------------------------
        -- Calculate TempsRequis and TempsBrut (in seconds)
        -------------------------------------------------------------------------
        SET @TempsRequis_sec = @Const_TempsRequis_sec - @SumPlanifier_sec;
        SET @TempsBrut_sec   = @TempsRequis_sec - @SumNonPlanifier_sec;
        SET @TempsBrut_ms    = @TempsBrut_sec * 1000;
        
        -------------------------------------------------------------------------
        -- Retrieve production data from Sacs_Produit for the given Cycle.
        -------------------------------------------------------------------------
        SELECT TOP 1 
            @N_Sacs_Total_Produit = N_Sacs_Total_Produit,
            @N_Sacs_Non_Conforme = N_Sacs_Non_Conforme
        FROM Sacs_Produit
        WHERE cycle = @Cycle;
        
        IF @N_Sacs_Total_Produit IS NULL
            SET @N_Sacs_Total_Produit = 0;
        IF @N_Sacs_Non_Conforme IS NULL
            SET @N_Sacs_Non_Conforme = 0;
        
        -------------------------------------------------------------------------
        -- DEFENSIVE CHECKS: Ensure denominators are valid for subsequent divisions.
        -------------------------------------------------------------------------
        IF @N_Sacs_Total_Produit <= 0
        BEGIN
            SET @ErrMsg = 'Error in Cycle ' + CONVERT(VARCHAR(50), @Cycle) 
                + ': N_Sacs_Total_Produit is zero or invalid; cannot calculate CadenceReel_s_Sac.';
            THROW 50001, @ErrMsg, 1;
        END
        IF @TempsBrut_sec <= 0
        BEGIN
            SET @ErrMsg = 'Error in Cycle ' + CONVERT(VARCHAR(50), @Cycle) 
                + ': TempsBrut_sec is zero; cannot calculate CadenceReel_s_Sac.';
            THROW 50002, @ErrMsg, 1;
        END

        -------------------------------------------------------------------------
        -- Calculation for CadenceReel_s_Sac:
        --   CadenceReel_Sac_h = (N_Sacs_Total_Produit * 3600) / TempsBrut_sec
        --   Then, CadenceReel_s_Sac = 3600 / CadenceReel_Sac_h.
        --
        -- Algebraically, this simplifies to:  
        --   CadenceReel_s_Sac = TempsBrut_sec / N_Sacs_Total_Produit.
        -------------------------------------------------------------------------
        SET @CadenceReel_Sac_sec = @TempsBrut_sec * 1.0 / @N_Sacs_Total_Produit;
        
        -------------------------------------------------------------------------
        -- Calculate EcartCadence_s_Sac:
        -- Difference between the (new) average time per sack (in ms) and a fixed 2.400 sec (2400 ms)
        -------------------------------------------------------------------------
        SET @EcartCadence_ms = ROUND(((@TempsBrut_sec * 1000.0 / @N_Sacs_Total_Produit) - @Const_EcartCadence_ms), 0);
        
        -------------------------------------------------------------------------
        -- Calculate Som_Temps_Ecart_Cadence:
        -- Multiply the cadence difference per sack by the number of sacks.
        -------------------------------------------------------------------------
        SET @Som_Temps_Ecart_Cadence_ms = @EcartCadence_ms * @N_Sacs_Total_Produit;
        
        -------------------------------------------------------------------------
        -- Calculate TempsNet_TDT: 
        -- Calculated as TempsBrut minus Som_Temps_Ecart_Cadence.
        -------------------------------------------------------------------------
        SET @TempsNet_TDT_ms = @TempsBrut_ms - @Som_Temps_Ecart_Cadence_ms;
        
        -------------------------------------------------------------------------
        -- Calculate Som_Temps_Production_Non_Qualite:
        -- Calculated as N_Sacs_Non_Conforme multiplied by 2.400 sec (2400 ms)
        -------------------------------------------------------------------------
        SET @Som_Temps_Production_Non_Qualite_ms = @N_Sacs_Non_Conforme * @Const_EcartCadence_ms;
        
        -------------------------------------------------------------------------
        -- Calculate TempsUtile:
        -- Calculated as TempsNet_TDT minus Som_Temps_Production_Non_Qualite.
        -------------------------------------------------------------------------
        SET @TempsUtile_ms = @TempsNet_TDT_ms - @Som_Temps_Production_Non_Qualite_ms;
         
        -------------------------------------------------------------------------
        -- Upsert (MERGE) the calculated values into Cycle_Production.
        -------------------------------------------------------------------------
        MERGE Cycle_Production AS target
        USING (SELECT @Cycle AS Cycle) AS source
        ON target.Cycle = source.Cycle
        WHEN MATCHED THEN
            UPDATE SET 
                N_Total_Arrets_Planifier       = @N_Total_Arrets_Planifier,
                Som_Temps_Arrets_Planifier     = CONVERT(TIME(7), DATEADD(SECOND, @SumPlanifier_sec, '00:00:00')),
                N_Total_Arrets_Non_Planifier   = @N_Total_Arrets_Non_Planifier,
                Som_Temps_Arrets_Non_Planifier = CONVERT(TIME(7), DATEADD(SECOND, @SumNonPlanifier_sec, '00:00:00')),
                TempsRequis                    = CONVERT(TIME(7), DATEADD(SECOND, @TempsRequis_sec, '00:00:00')),
                TempsBrut                      = CONVERT(TIME(7), DATEADD(SECOND, @TempsBrut_sec, '00:00:00')),
                -- Use TIMEFROMPARTS to display fractional seconds for CadenceReel_s_Sac:
                CadenceReel_s_Sac = TIMEFROMPARTS(
                                        0, 
                                        0, 
                                        FLOOR(@CadenceReel_Sac_sec), 
                                        ROUND((@CadenceReel_Sac_sec - FLOOR(@CadenceReel_Sac_sec)) * 1000000, 0),
                                        6
                                    ),
                EcartCadence_s_Sac             = CONVERT(TIME(7), DATEADD(MILLISECOND, @EcartCadence_ms, '00:00:00')),
                Som_Temps_Ecart_Cadence        = CONVERT(TIME(7), DATEADD(MILLISECOND, @Som_Temps_Ecart_Cadence_ms, '00:00:00')),
                TempsNet_TDT                   = CONVERT(TIME(7), DATEADD(MILLISECOND, @TempsNet_TDT_ms, '00:00:00')),
                Som_Temps_Production_Non_Qualite = CONVERT(TIME(7), DATEADD(MILLISECOND, @Som_Temps_Production_Non_Qualite_ms, '00:00:00')),
                TempsUtile                   = CONVERT(TIME(7), DATEADD(MILLISECOND, @TempsUtile_ms, '00:00:00'))
        WHEN NOT MATCHED THEN
            INSERT (Cycle, N_Total_Arrets_Planifier, Som_Temps_Arrets_Planifier, 
                    N_Total_Arrets_Non_Planifier, Som_Temps_Arrets_Non_Planifier, 
                    TempsRequis, TempsBrut, CadenceReel_s_Sac, EcartCadence_s_Sac, 
                    Som_Temps_Ecart_Cadence, TempsNet_TDT, Som_Temps_Production_Non_Qualite, TempsUtile)
            VALUES (
                @Cycle,
                @N_Total_Arrets_Planifier,
                CONVERT(TIME(7), DATEADD(SECOND, @SumPlanifier_sec, '00:00:00')),
                @N_Total_Arrets_Non_Planifier,
                CONVERT(TIME(7), DATEADD(SECOND, @SumNonPlanifier_sec, '00:00:00')),
                CONVERT(TIME(7), DATEADD(SECOND, @TempsRequis_sec, '00:00:00')),
                CONVERT(TIME(7), DATEADD(SECOND, @TempsBrut_sec, '00:00:00')),
                TIMEFROMPARTS(
                    0, 
                    0, 
                    FLOOR(@CadenceReel_Sac_sec), 
                    ROUND((@CadenceReel_Sac_sec - FLOOR(@CadenceReel_Sac_sec)) * 1000000, 0),
                    6
                ),
                CONVERT(TIME(7), DATEADD(MILLISECOND, @EcartCadence_ms, '00:00:00')),
                CONVERT(TIME(7), DATEADD(MILLISECOND, @Som_Temps_Ecart_Cadence_ms, '00:00:00')),
                CONVERT(TIME(7), DATEADD(MILLISECOND, @TempsNet_TDT_ms, '00:00:00')),
                CONVERT(TIME(7), DATEADD(MILLISECOND, @Som_Temps_Production_Non_Qualite_ms, '00:00:00')),
                CONVERT(TIME(7), DATEADD(MILLISECOND, @TempsUtile_ms, '00:00:00'))
            );
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END

GO


