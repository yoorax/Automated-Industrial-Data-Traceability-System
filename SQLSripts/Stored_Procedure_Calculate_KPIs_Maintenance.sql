USE [LigneEnsacheuse ]
GO

/****** Object:  StoredProcedure [dbo].[Calculate_KPIs_Maintenance_For_Cycle]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------------------------
-- 1. Stored Procedure: Calculate_KPIs_Maintenance_For_Cycle
--------------------------------------------------------------------------------
ALTER   PROCEDURE [dbo].[Calculate_KPIs_Maintenance_For_Cycle]
    @Cycle DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        ----------------------------------------------------------------------------
        -- Variable declarations
        ----------------------------------------------------------------------------
        DECLARE 
            @TempsBrut_sec INT,                  -- from Cycle_Production converted to seconds
            @N_Total_Arrets_Non_Planifier INT,     -- from Cycle_Production
            @SomArretsNonPlanifier_sec INT,        -- from Cycle_Production: Som_Temps_Arrets_Non_Planifier in seconds
            @DureeIntervention_Total_sec INT,      -- from Arrets_Non_Planifier: SUM of Duree_Intervention (in seconds)
            @DureeArretPlanifier_Maintenance_sec INT,  -- from Arrets_Planifier (Maintenance category) in seconds
            @MTBF_sec INT,                       -- Mean Time Between Failures (in seconds)
            @MTTR_sec INT;                       -- Mean Time To Repair (in seconds)
        
        DECLARE 
            @TauxDefaillance DECIMAL(6,4),       -- Failure Rate = 1/MTBF (in hours)
            @TauxReparation DECIMAL(6,4),        -- Repair Rate  = 1/MTTR (in hours)
            @TauxReactivite DECIMAL(6,4),        -- Reactivity Rate (%)
            @TMP DECIMAL(6,4);                   -- Total Maintenance Time Percentage (%)

        ----------------------------------------------------------------------------
        -- Retrieve data from Cycle_Production for the given Cycle:
        -- Convert TempsBrut and Som_Temps_Arrets_Non_Planifier to seconds.
        ----------------------------------------------------------------------------
        SELECT TOP 1 
            @TempsBrut_sec = DATEDIFF(SECOND, '00:00:00', TempsBrut),
            @N_Total_Arrets_Non_Planifier = N_Total_Arrets_Non_Planifier,
            @SomArretsNonPlanifier_sec = ISNULL(DATEDIFF(SECOND, '00:00:00', Som_Temps_Arrets_Non_Planifier), 0)
        FROM Cycle_Production
        WHERE Cycle = @Cycle;
        
        ----------------------------------------------------------------------------
        -- Retrieve total intervention duration from Arrets_Non_Planifier (in seconds)
        ----------------------------------------------------------------------------
        SELECT 
            @DureeIntervention_Total_sec = ISNULL(SUM(DATEDIFF(SECOND, '00:00:00', Duree_Intervention)), 0)
        FROM Arrets_Non_Planifier
        WHERE Cycle = @Cycle;
        
        ----------------------------------------------------------------------------
        -- Retrieve total maintenance downtime from Arrets_Planifier for Maintenance
        ----------------------------------------------------------------------------
        SELECT 
            @DureeArretPlanifier_Maintenance_sec = ISNULL(SUM(DATEDIFF(SECOND, '00:00:00', Duree_Arret_Planifier)), 0)
        FROM Arrets_Planifier
        WHERE Cycle = @Cycle 
          AND Categorie_Arret_Planifier = 'Maintenance';
        
        ----------------------------------------------------------------------------
        -- Calculate MTBF (Mean Time Between Failures)
        -- Formula: MTBF = TempsBrut / N_Total_Arrets_Non_Planifier
        ----------------------------------------------------------------------------
        IF @N_Total_Arrets_Non_Planifier > 0
            SET @MTBF_sec = @TempsBrut_sec / @N_Total_Arrets_Non_Planifier;
        ELSE
            SET @MTBF_sec = 0;
        
        ----------------------------------------------------------------------------
        -- Calculate MTTR (Mean Time To Repair)
        -- Formula: MTTR = Som_Temps_Arrets_Non_Planifier / N_Total_Arrets_Non_Planifier
        ----------------------------------------------------------------------------
        IF @N_Total_Arrets_Non_Planifier > 0
            SET @MTTR_sec = @SomArretsNonPlanifier_sec / @N_Total_Arrets_Non_Planifier;
        ELSE
            SET @MTTR_sec = 0;
        
        ----------------------------------------------------------------------------
        -- TauxDefaillance (Failure Rate):
        -- Formula: 1 / MTBF_h, where MTBF_h = MTBF_sec / 3600.
        ----------------------------------------------------------------------------
        IF @MTBF_sec > 0
            SET @TauxDefaillance = 1.0 / (@MTBF_sec / 3600.0);
        ELSE
            SET @TauxDefaillance = NULL;
        
        ----------------------------------------------------------------------------
        -- TauxReparation (Repair Rate):
        -- Formula: 1 / MTTR_h, where MTTR_h = MTTR_sec / 3600.
        ----------------------------------------------------------------------------
        IF @MTTR_sec > 0
            SET @TauxReparation = 1.0 / (@MTTR_sec / 3600.0);
        ELSE
            SET @TauxReparation = NULL;
        
        ----------------------------------------------------------------------------
        -- TauxReactivite (Reactivity Rate):
        -- Formula: (1 - (DureeIntervention_Total_sec / SomArretsNonPlanifier_sec)) * 100
        ----------------------------------------------------------------------------
        IF @SomArretsNonPlanifier_sec > 0
            SET @TauxReactivite = (1 - (@DureeIntervention_Total_sec * 1.0 / @SomArretsNonPlanifier_sec)) * 100;
        ELSE
            SET @TauxReactivite = NULL;
        
        ----------------------------------------------------------------------------
        -- TMP (Total Maintenance Time Percentage):
        -- Formula: (DureeArretPlanifier_Maintenance_sec / 
        --           (DureeArretPlanifier_Maintenance_sec + DureeIntervention_Total_sec)) * 100
        ----------------------------------------------------------------------------
        IF (@DureeArretPlanifier_Maintenance_sec + @DureeIntervention_Total_sec) > 0
            SET @TMP = (@DureeArretPlanifier_Maintenance_sec * 1.0 / (@DureeArretPlanifier_Maintenance_sec + @DureeIntervention_Total_sec)) * 100;
        ELSE
            SET @TMP = NULL;
        
        ----------------------------------------------------------------------------
        -- Upsert the calculated KPIs into KPIs_Maintenance
        ----------------------------------------------------------------------------
        MERGE KPIs_Maintenance AS target
        USING (SELECT @Cycle AS Cycle) AS source
        ON target.Cycle = source.Cycle
        WHEN MATCHED THEN
            UPDATE SET 
                MTBF = CONVERT(TIME(7), DATEADD(SECOND, @MTBF_sec, '00:00:00')),
                MTTR = CONVERT(TIME(7), DATEADD(SECOND, @MTTR_sec, '00:00:00')),
                TauxDefaillance = @TauxDefaillance,
                TauxReparation = @TauxReparation,
                TauxReactivite = @TauxReactivite,
                TMP = @TMP
        WHEN NOT MATCHED THEN
            INSERT (Cycle, MTBF, MTTR, TauxDefaillance, TauxReparation, TauxReactivite, TMP)
            VALUES (
                @Cycle,
                CONVERT(TIME(7), DATEADD(SECOND, @MTBF_sec, '00:00:00')),
                CONVERT(TIME(7), DATEADD(SECOND, @MTTR_sec, '00:00:00')),
                @TauxDefaillance,
                @TauxReparation,
                @TauxReactivite,
