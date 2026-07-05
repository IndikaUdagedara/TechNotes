# Displays

## kanshi + wdisplays

#kanshi #monitors

### Workflow
1. **Arrange with wdisplays** — open `wdisplays`, drag and configure outputs visually, click *Apply*. Changes are live but temporary.
2. **Save with kanshi-save-current** — once the layout looks right, run:
   ```bash
   kanshi-save-current home-desk
   ```
   Reads current sway output state (make/model/serial, resolution, position) and appends a named profile to `~/.config/kanshi/config`.
3. **kanshi auto-applies** — on next connect, kanshi matches the profile by make + model + serial and applies it automatically.

### Notes
- Reload kanshi after saving a new profile: `kanshictl reload`
- `kanshi-save-current` does not capture `scale` or `transform` — add these manually if needed.
- Each unique physical monitor combination needs its own named profile.
- Profiles match on all three of make + model + serial.