-- CodeVibes event RSVP hardening migration
-- Run in Supabase SQL Editor. Existing event deletion cascades to its RSVP rows.
ALTER TABLE public.event_rsvps
  DROP CONSTRAINT IF EXISTS event_rsvps_event_id_fkey;
ALTER TABLE public.event_rsvps
  ADD CONSTRAINT event_rsvps_event_id_fkey
  FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_event_rsvps_event_created
  ON public.event_rsvps(event_id, created_at DESC);

-- Prevent the same email from registering twice for one event.
CREATE UNIQUE INDEX IF NOT EXISTS uq_event_rsvps_event_email
  ON public.event_rsvps(event_id, lower(email));

-- The backend must use the Supabase SERVICE ROLE key (server-side only).
-- Never put the service role key in VITE_* variables or frontend code.
-- Keep RLS enabled; service role bypasses RLS. Do not add public SELECT policies
-- for event_rsvps because that would expose attendee personal information.
