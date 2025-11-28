# Setup Guide - Game of Life Web Game

Complete step-by-step guide to set up and run the full-stack Game of Life web game.

## Prerequisites

Before you start, make sure you have:

1. **Julia 1.6 or higher**
   - Download from: https://julialang.org/downloads/
   - Verify: `julia --version`

2. **Node.js 18 or higher**
   - Download from: https://nodejs.org/
   - Verify: `node --version` and `npm --version`

3. **Git** (optional, for cloning)
   - Download from: https://git-scm.com/

## Installation Steps

### Step 1: Clone or Download the Project

```bash
# Using git
git clone <repository-url>
cd game-of-life-web

# Or download and extract the ZIP file
```

### Step 2: Set Up the Backend (Julia API)

#### 2.1 Navigate to API directory
```bash
cd api
```

#### 2.2 Install Julia dependencies
```bash
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

This will download and install:
- HTTP.jl (web server)
- JSON.jl (JSON serialization)
- UUIDs.jl (session IDs)
- Dates.jl (timestamps)

**Expected output:**
```
Precompiling project...
  142 dependencies successfully precompiled in 223 seconds.
```

#### 2.3 Verify backend setup
```bash
julia --project=. -e "using GameOfLifeAPI; println(\"Backend ready!\")"
```

### Step 3: Set Up the Frontend (Next.js)

#### 3.1 Navigate to web directory
```bash
cd ../web
```

#### 3.2 Install Node dependencies
```bash
npm install
```

This will install:
- Next.js 14
- React 18
- TypeScript
- Tailwind CSS
- And other dependencies

**Expected output:**
```
added 500+ packages in 2m
```

#### 3.3 Create environment file
```bash
# Copy example environment file
cp .env.example .env.local

# Or create manually with:
echo "NEXT_PUBLIC_API_URL=http://localhost:8000" > .env.local
```

#### 3.4 Verify frontend setup
```bash
npm run build
```

This should complete without errors.

## Running the Application

### Terminal 1: Start the Backend API

```bash
cd api
julia --project=. -e "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"
```

**Expected output:**
```
Starting Game of Life API server on port 8000...
```

The API will be available at: `http://localhost:8000`

### Terminal 2: Start the Frontend

```bash
cd web
npm run dev
```

**Expected output:**
```
  ▲ Next.js 14.0.0
  - Local:        http://localhost:3000
  - Environments: .env.local
```

The frontend will be available at: `http://localhost:3000`

### Step 4: Open in Browser

1. Open your browser
2. Navigate to: `http://localhost:3000`
3. You should see the Game of Life interface
4. Start playing!

## Troubleshooting

### Issue: "Failed to connect to API"

**Solution:**
1. Verify Julia API is running on port 8000
2. Check `.env.local` has correct API URL
3. Ensure no firewall is blocking port 8000
4. Try: `curl http://localhost:8000/api/game/new`

### Issue: "Module not found" in Julia

**Solution:**
```bash
cd api
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

### Issue: "npm ERR! code ERESOLVE"

**Solution:**
```bash
cd web
npm install --legacy-peer-deps
```

### Issue: Port 8000 or 3000 already in use

**Solution:**
```bash
# Change API port (in api/src/api.jl):
GameOfLifeAPI.start_server(8001)

# Change frontend port:
npm run dev -- -p 3001
```

### Issue: Grid not rendering

**Solution:**
1. Check browser console (F12) for errors
2. Verify API is responding: `curl http://localhost:8000/api/game/new`
3. Clear browser cache and reload
4. Try a different browser

## Development Mode

### Hot Reload
- **Frontend:** Changes to `.tsx` files auto-reload
- **Backend:** Requires manual restart

### Debug Mode
```bash
# Frontend with debug logging
npm run dev

# Backend with verbose output
julia --project=. -e "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"
```

## Production Build

### Frontend
```bash
cd web
npm run build
npm start
```

### Backend
```bash
cd api
julia --project=. -e "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"
```

## Docker Setup (Optional)

### Build Docker Image
```bash
docker build -t game-of-life-api -f api/Dockerfile .
docker build -t game-of-life-web -f web/Dockerfile .
```

### Run with Docker Compose
```bash
docker-compose up
```

## Environment Variables

### Frontend (.env.local)
```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Backend (api/src/api.jl)
```julia
const API_PORT = 8000
const API_HOST = "127.0.0.1"
```

## Testing

### Backend Tests
```bash
cd api
julia --project=. test/runtests.jl
```

### Frontend Tests
```bash
cd web
npm test
```

## Performance Tips

1. **Reduce grid updates:** Lower game speed
2. **Optimize rendering:** Use browser DevTools
3. **Monitor memory:** Check Julia/Node memory usage
4. **Cache patterns:** Pre-compute pattern data

## Next Steps

1. **Play the game:** Try different patterns and strategies
2. **Customize:** Modify colors, difficulty, grid size
3. **Deploy:** Follow deployment guide in FULLSTACK_README.md
4. **Extend:** Add new features (multiplayer, power-ups, etc.)

## Getting Help

- Check FULLSTACK_README.md for detailed documentation
- Review component code in `web/components/`
- Check Julia API code in `api/src/`
- Open an issue on GitHub

## Quick Reference

| Command | Purpose |
|---------|---------|
| `julia --project=. -e "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"` | Start API |
| `npm run dev` | Start frontend dev server |
| `npm run build` | Build frontend for production |
| `npm test` | Run frontend tests |
| `julia --project=. test/runtests.jl` | Run backend tests |

---

**You're all set! Enjoy the Game of Life! 🎮**
