# Sleep Quiz Funnel

Selbst-enthaltener Quiz-Funnel für eine Hotel-Matratzen-Lead-Kampagne.
Gast scannt QR-Code → 5 Schlaf-Fragen → Kontaktformular → Schlaf-Score.
Beim Absenden geht ein JSON-POST an einen n8n-Webhook.

## Anpassen (alles in `index.html` ganz oben im `<script>`)

| Was | Wo |
|-----|-----|
| **Webhook-URL** | `const WEBHOOK_URL = "...";` |
| **Fragen & Punkte** | `const QUESTIONS = [...]` |
| **Score-Buckets** (in %) | `const SCORE_BUCKETS = [...]` |
| **Akzentfarbe** | CSS-Variable `--accent` im `:root`-Block |
| **Logo** | `.brand` im `<body>` (Text oder `<img class="logo-img">`) |

## hotel_id

Wird aus der URL gelesen:
1. Query-Param `?h=<id>`  → z. B. `index.html?h=hotel-graz-01`
2. sonst Pfad-Segment `/h/<id>`
3. sonst `"unknown"`

## Lokal testen

Einfach `index.html` per Doppelklick (`file://`) öffnen – oder statisch servieren:

```bash
npx serve .            # oder: python3 -m http.server 8080
```

## Deploy (Coolify)

Dieses Repo bringt ein minimales `Dockerfile` (nginx:alpine) + `nginx.conf` mit –
Coolify baut daraus den statischen Funnel.

1. In Coolify: **New Resource → Public Repository**, diese Repo-URL eintragen.
2. **Build Pack: Dockerfile**, **Port: 80**.
3. Domain/Subdomain zuweisen → Coolify zieht das TLS-Zertifikat (Let's Encrypt).
4. Deploy. Bei jedem `git push` kann Coolify automatisch neu bauen.

Die `nginx.conf` leitet alle Pfade auf `index.html` um, damit neben `?h=<id>` auch
die `/h/<id>`-URL-Variante funktioniert.

## Payload-Shape (an n8n)

```json
{
  "source": "sleep-funnel",
  "hotel_id": "hotel-graz-01",
  "score": 38,
  "score_max": 50,
  "score_percent": 76,
  "score_label": "Sehr gut",
  "answers": [
    { "question_id": "q1", "question": "...", "answer": "Gut", "points": 8 }
  ],
  "contact": { "name": "...", "email": "...", "phone": "..." },
  "consent": true,
  "submitted_at": "2026-06-13T10:32:00.000Z"
}
```

## Nicht im MVP (später)

- Cloudflare Turnstile statt nur Honeypot (`turnstile_token` ins Payload, n8n verifiziert).
- A/B-Varianten / ausführlicheres Branding.
