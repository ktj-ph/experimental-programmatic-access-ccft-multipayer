CREATE OR REPLACE VIEW "carbon_emissions_view_total" AS 
SELECT
  cet.accountid
, cet.query.querydate
, entries.startdate
, SUM(entries.mbmcarbon) mbmcarbon
, inefficiency.gridmixinefficiency gridmixinefficiency
, (SUM(entries.mbmcarbon) + inefficiency.gridmixinefficiency) mbmcarbonandgridmixinefficiency
FROM
  (("carbon_emissions_table" cet
CROSS JOIN UNNEST(cet.emissions.carbonemissionentries) t (entries))
CROSS JOIN UNNEST(cet.emissions.carbonemissionsinefficiency) t (inefficiency))
WHERE (entries.startdate = inefficiency.startdate)
GROUP BY cet.accountid, cet.query.querydate, entries.startdate, inefficiency.gridmixinefficiency
