there is a problem with trigger_value/2
- constraining stepping exactly at 10 causes "no models"
  :- normal_atom(valueAtStep(brightness, S), gt, 10), normal_atom(valueAtStep(brightness, S+1), lt, 10), step(S), step(S+1).
- this is a constraint which is not needed because the trajectory will never try to approach 10 from above
- but why does it cause problems?