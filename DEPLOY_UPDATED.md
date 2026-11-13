# Updated CodeVibes deployment notes

## Required configuration before building
1. In `frontend/.env.production`, replace `https://YOUR-RENDER-BACKEND.onrender.com` with the exact public URL shown by your Render service. No trailing slash.
2. In Render environment variables set `SUPABASE_URL` and `SUPABASE_KEY`. `SUPABASE_KEY` must be the Supabase **service_role** key because the API performs server-side writes and reads of private RSVP records. Never put this key in the frontend or any `VITE_` variable.
3. Set `CORS_ORIGINS=https://thecodevibes.online` (add any other real frontend origin as a comma-separated value).
4. Set a strong private `ADMIN_PASSWORD`; do not use the sample/default value.

## Supabase
Run `backend/event_rsvp_migration.sql` in Supabase SQL Editor. This enforces unique event/email registrations and ensures deleting an event cascades to its RSVP records. Keep RLS enabled. Do not create a public SELECT policy on `event_rsvps`.

## Deploy backend (Render)
Upload/push the updated `backend` folder to the repository connected to Render. Render build command: `pip install -r requirements.txt`; start command: `uvicorn main:app --host 0.0.0.0 --port $PORT`. Deploy and test `/api/health`.

## Deploy frontend (Netlify Drop)
From the `frontend` folder run:
- `npm install`
- `npm run build`
Then drag the generated `frontend/dist` folder into the Netlify manual deploy area for the existing site. Because this is a Vite app, environment variables are baked into the build; editing Netlify variables alone does not update an already-uploaded Drop deployment.

## Behaviour
- Events and RSVPs are persisted in Supabase when configured; database failures return errors rather than pretending data was saved in process memory.
- Admin deleting an event removes it globally for all visitors because all visitors read from the same API/database. The database foreign key cascades and deletes its RSVP rows too.
- Closing registration leaves the event visible but blocks new registrations. Deleting removes it from all event lists.
- The API currently inherits the project's existing admin-login model. Before handling real personal data in production, protect admin-only event/RSVP endpoints with server-verified authentication/authorization; a frontend-only admin gate is not a security boundary.
