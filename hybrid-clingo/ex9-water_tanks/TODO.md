There are problems here.

1) cant just use trigger_value/2 to force seeing steps with the target water level because the events are not always triggered at this timepoint
   - a workaround seems to be to trigger an aux__ event when there is not switch event

2) cant use trigger_value/2 because it restricts seeing the trigger value from both directions (increasing and decreasing) and that causes "no models" for some reason
   - a solution is to only constraint the direction that we actually care about here (so only decreasing) -- not sure how general this is
   - no idea why it is happening in the first place

3) it is hard to introduce trigger_value/2 to the minimum duration between switches
   - cant get the normal trigger_value/2 or even a manual version to work properly
   - model-fixed1.lp currently just does not have this constraint implemented (works for this example, but might not in general)
   - model-fixed2.lp uses a diff approach which seems to work well -- instead of checking the time difference between the start of the trajectory and the potential switch event
     it explicitly models an aux__ event for the end of the minimum duration and this event is scheduled as a regular triggered event -- it works but is complicated
