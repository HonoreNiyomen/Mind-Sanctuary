# MindSanctuary - System overview

MindSanctuary is a non-clinical, university-centered wellbeing SaaS built with Phoenix LiveView for reactive UI and Phoenix Channels for anonymous peer chat. Core subsystems:

* Auth & Identity (student and volunteer roles; anonymous chat identity).

* Mood Tracker (daily check-ins, simple analytics).

* Resource Hub (audio files, articles, contact info — university-tagged).

* Anonymous Peer Support (real-time chat pairing students with volunteers).

* Events / Workshops (listing, RSVP, calendar export).

* Admin dashboard (manage resources, see queue, moderate).

* Background workers (deliver digests, schedule pairing, generate analytics).

## MVP features

1. Auth (university email sign-up + role selection).

2. Mood Tracker with simple timeline view.

3. Resource Hub (text + audio streaming via signed URLs).

4. Anonymous peer chat pairing + chat UI (one-to-one).

5. Basic moderation/reporting flow and profanity filtering.
Stretch (coming soon):

  * Calendar integration / notifications.

  * Scheduled workshops & RSVP reminders.

  * Sentiment analytics / charts.

  * Rich media uploads by volunteers.

  * SSO with university (SAML/OAuth).


# Endpoints & LiveViews (minimal)

* `/` — landing LiveView
* `/auth/*` — registration/login via generated auth
* `/mood` — Mood tracker LiveView + POST endpoint
* `/resources` — Resource hub LiveView
* `/resources/new`, `/resources/:id/edit` — Admin LiveViews
* `/chat` — Request chat / Public Chat component (LiveView or form)
* `/volunteer/dashboard` — volunteer LiveView (queue + active)
* `/chat/:id` — chat LiveView that connects to Channel topic
* `/calendar` — Event listing LiveView
* `/dashboard` — General dashboard (landing page)
* `/admin` — Admin dashboard (flags, usage metrics)

# How to Run System

1. **Clone the repo:**
   ```bash
   git clone https://github.com/HonoreNiyomen/Mind-Sancuary.git
   cd Mind-Sancuary

2. **To start your Phoenix server**
    * On an environment with **erlang v28.0+**, **elixir v1.18+** and **postgresql v16+** setup:
   ```bash
   mix setup ## to install and setup dependencies
   mix phx.server ## which will run the app on port 4000