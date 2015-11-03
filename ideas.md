For every stop

- conditional distribution of arrival times, conditioned on
  - previous arrival
  - scheduled arrival
  - nearest bus location
  - other buses' timeliness at this moment in this vacinity.
  
  
track each bus's position relative to

- expected position (by the schedule)
- mean position (by the time)

Could have conditional distribution of bus positions, aggregated by tracking buses over a period of weeks

- Try this first using a single bus, e.g. B43. 
- Record each bus's location every update (~30s), as well as the expected position based on scheduling.