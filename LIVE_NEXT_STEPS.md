# Code Vibe — Live Deploy (Next Steps)

## Admin login (site live hone ke baad)
- URL: `https://YOUR-SITE.netlify.app/admin`
- Email: `admin@thecodevibe.io`
- Password: `CODEVIBES2007`

---

## Order (yeh sequence follow karo)

### 1) Backend → Render (pehle yeh)

1. https://render.com → New → **Web Service**
2. Repo connect karo **ya** `backend` folder upload / connect
3. Settings:
   - **Root Directory:** `backend` (agar pura repo hai)
   - **Build:** `pip install -r requirements.txt`
   - **Start:** `uvicorn main:app --host 0.0.0.0 --port $PORT`
4. Environment variables (Render → Environment):

```
ENVIRONMENT=production
ADMIN_EMAIL=admin@thecodevibe.io
ADMIN_PASSWORD=CODEVIBES2007
CORS_ORIGINS=*
NOTIFY_EMAIL=thecodevibehack@gmail.com
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=thecodevibehack@gmail.com
SMTP_PASSWORD=<Gmail App Password 16 chars, no spaces>
SMTP_FROM=The Code Vibe <thecodevibehack@gmail.com>
```

5. Deploy → backend URL copy karo, example:  
   `https://code-vibe-api.onrender.com`
6. Test: browser me open karo  
   `https://YOUR-BACKEND.onrender.com/api/health`

---

### 2) Frontend → Netlify

1. https://app.netlify.com → Add new site
2. Git se import **ya** drag-drop (base = repo root, Netlify `netlify.toml` use karega)
3. Build settings (agar auto nahi aaye):
   - **Base directory:** `frontend`
   - **Build command:** `npm run build`
   - **Publish directory:** `frontend/dist`
4. **Environment variables** (Site settings → Environment variables → Build):

```
VITE_API_BASE_URL=https://YOUR-BACKEND.onrender.com
VITE_CONTACT_EMAIL=thecodevibehack@gmail.com
VITE_ADMIN_EMAILS=admin@thecodevibe.io
```

**Important:** `VITE_API_BASE_URL` me trailing slash `/` mat lagana.  
Backend URL wahi jo Render ne diya.

5. Deploy → Netlify URL mil jayega: `https://something.netlify.app`

---

### 3) CORS lock (optional but recommended)

Render → Environment → `CORS_ORIGINS` update:

```
https://something.netlify.app
```

Save → Render auto-redeploy.

---

### 4) Live test checklist

- [ ] Home page load
- [ ] Events → More Details → sahi event open
- [ ] **RSVP • Register Free** → form dikhe → login → submit
- [ ] `/admin` → `admin@thecodevibe.io` / `CODEVIBES2007` → dashboard
- [ ] Admin se naya event create + registration questions add
- [ ] Collaborate form submit (email SMTP set ho to inbox me aaye)

---

## Gmail App Password (email forms ke liye)

1. https://myaccount.google.com/security → 2-Step Verification ON
2. https://myaccount.google.com/apppasswords → App: Mail → generate
3. 16-char password Render pe `SMTP_PASSWORD` me paste (spaces hata ke)

SMTP optional hai — events/admin API bina SMTP bhi chalega. Sirf email notification ke liye chahiye.

---

## Local run (optional)

```bash
# Terminal 1
cd backend
pip install -r requirements.txt
python main.py

# Terminal 2
cd frontend
npm install
npm run dev
```

Open: http://localhost:5173  
Admin: http://localhost:5173/admin

---

## Common issues

| Problem | Fix |
|--------|-----|
| Admin login fail | Render pe `ADMIN_PASSWORD=CODEVIBES2007` set hai? |
| Events form nahi | RSVP button pe click; registration open honi chahiye |
| API not found on Netlify | `VITE_API_BASE_URL` set karke **rebuild** (env change ke baad redeploy zaroori) |
| CORS error | Render `CORS_ORIGINS=*` ya exact Netlify URL |
| Render slow first load | Free tier sleep — 30–60s wait normal |
