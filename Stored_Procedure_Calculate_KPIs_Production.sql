USE [LigneEnsacheuse ]
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateKPIsProduction]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_UpdateKPIsProduction]
    @Cycle DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        ---------------------------------------------------------------------
        -- 1) KPI output variables (DECIMAL for precision)
        ---------------------------------------------------------------------
        DECLARE
            @TSE              DECIMAL(10,2),
            @TauxCharge       DECIMAL(10,2),
            @TauxPerformance  DECIMAL(10,2),
            @TDT              DECIMAL(10,2),
            @TauxQualite      DECIMAL(10,2),
            @TRS              DECIMAL(10,2),
            @TRG              DECIMAL(10,2),
            @TRE              DECIMAL(10,2);

        ---------------------------------------------------------------------
        -- 2) Intermediate variables
        ---------------------------------------------------------------------
        DECLARE
            @TempsRequis_sec           INT,
            @TempsBrut_sec             INT,
            @CadenceReel_s_Sac_sec     DECIMAL(10,6),
            @CadenceReel_Sac_h         DECIMAL(10,2),
            @N_Sacs_Total_Produit      SMALLINT,
            @N_Sacs_Non_Conforme       SMALLINT;

        ---------------------------------------------------------------------
        -- 3) TSE = (16h ÷ 24h) × 100
        ---------------------------------------------------------------------
        SET @TSE = ROUND((16.0/24) * 100, 2);

        ---------------------------------------------------------------------
        -- 4) Retrieve from Cycle_Production:
        --    TempsRequis & TempsBrut in seconds,
        --    CadenceReel_s_Sac in seconds with ms
        ---------------------------------------------------------------------
        SELECT TOP 1
            @TempsRequis_sec       = DATEDIFF(SECOND,  '00:00:00', TempsRequis),
            @TempsBrut_sec         = DATEDIFF(SECOND,  '00:00:00', TempsBrut),
            @CadenceReel_s_Sac_sec = DATEDIFF(MILLISECOND,'00:00:00',CadenceReel_s_Sac) * 1.0/1000.0
        FROM Cycle_Production
        WHERE Cycle = @Cycle;

        ---------------------------------------------------------------------
        -- 5) Retrieve from Sacs_Produit
        ---------------------------------------------------------------------
        SELECT TOP 1
            @N_Sacs_Total_Produit = N_Sacs_Total_Produit,
            @N_Sacs_Non_Conforme  = N_Sacs_Non_Conforme
        FROM Sacs_Produit
        WHERE cycle = @Cycle;

        -- Default any NULL to 0
        IF @TempsRequis_sec       IS NULL SET @TempsRequis_sec       = 0;
        IF @TempsBrut_sec         IS NULL SET @TempsBrut_sec         = 0;
        IF @CadenceReel_s_Sac_sec IS NULL SET @CadenceReel_s_Sac_sec = 0;
        IF @N_Sacs_Total_Produit  IS NULL SET @N_Sacs_Total_Produit  = 0;
        IF @N_Sacs_Non_Conforme   IS NULL SET @N_Sacs_Non_Conforme   = 0;

        ---------------------------------------------------------------------
        -- 6) TauxCharge = (TempsRequis_sec ÷ 57600) × 100
        ---------------------------------------------------------------------
        SET @TauxCharge = CASE
            WHEN 57600 > 0 THEN ROUND((@TempsRequis_sec * 100.0) / 57600, 2)
            ELSE 0
        END;

        ---------------------------------------------------------------------
        -- 7) Cadence réelle en sacs/heure
        ---------------------------------------------------------------------
        SET @CadenceReel_Sac_h = CASE
            WHEN @CadenceReel_s_Sac_sec > 0
            THEN 3600.0 / @CadenceReel_s_Sac_sec
            ELSE 0
        END;

        ---------------------------------------------------------------------
        -- 8) TauxPerformance = (CadenceRéelle_sac_h ÷ 1500) × 100
        ---------------------------------------------------------------------
        SET @TauxPerformance = CASE
            WHEN @CadenceReel_Sac_h > 0 THEN ROUND((@CadenceReel_Sac_h / 1500.0) * 100, 2)
            ELSE 0
        END;

        ---------------------------------------------------------------------
        -- 9) TDT = (TempsBrut_sec ÷ TempsRequis_sec) × 100
        ---------------------------------------------------------------------
        SET @TDT = CASE
            WHEN @TempsRequis_sec > 0 THEN ROUND((@TempsBrut_sec * 100.0) / @TempsRequis_sec, 2)
            ELSE 0
        END;

        ---------------------------------------------------------------------
        -- 10) TauxQualite = (1 – NonConformes ÷ Total) × 100
        ---------------------------------------------------------------------
        SET @TauxQualite = CASE
            WHEN @N_Sacs_Total_Produit > 0
            THEN ROUND((1 - (@N_Sacs_Non_Conforme * 1.0 / @N_Sacs_Total_Produit)) * 100, 2)
            ELSE 0
        END;

        ---------------------------------------------------------------------
        -- 11) TRS = (TauxQualite × TauxPerformance × TDT) ÷ 10000
        ---------------------------------------------------------------------
        SET @TRS = ROUND((@TauxQualite * @TauxPerformance * @TDT) / 10000.0, 2);

        ---------------------------------------------------------------------
        -- 12) TRG = (TauxCharge × TRS) ÷ 100
        ---------------------------------------------------------------------
        SET @TRG = ROUND((@TauxCharge * @TRS) / 100.0, 2);

        ---------------------------------------------------------------------
        -- 13) TRE = (TSE × TRS × TauxCharge) ÷ 10000
        ---------------------------------------------------------------------
        SET @TRE = ROUND((@TSE * @TRS * @TauxCharge) / 10000.0, 2);

        ---------------------------------------------------------------------
        -- 14) MERGE into KPIs_Production
        ---------------------------------------------------------------------
        MERGE KPIs_Production AS target
        USING (SELECT @Cycle AS Cycle) AS source
            ON target.Cycle = source.Cycle
        WHEN MATCHED THEN
            UPDATE SET
                TSE             = @TSE,
                TauxCharge      = @TauxCharge,
                TauxPerformance = @TauxPerformance,
                TDT             = @TDT,
                TauxQualite     = @TauxQualite,
                TRS             = @TRS,
                TRG             = @TRG,
                TRE             = @TRE
        WHEN NOT MATCHED THEN
            INSERT (Cycle, TSE, TauxCharge, TauxPerformance, TDT, TauxQualite, TRS, TRG, TRE)
            VALUES (@Cycle, @TSE, @TauxCharge, @TauxPerformance, @TDT, @TauxQualite, @TRS, @TRG, @TRE);

    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END

GO


