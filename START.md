# Quick Start - Game of Life Web Game

## 🚀 Get Running in 5 Minutes

### Prerequisites Check
```bash
julia --version    # Should be 1.6+
node --version     # Should be 18+
npm --version      # Should be 9+
```

### Step 1: Install Backend Dependencies (2 min)
```bash
cd api
julia --project=. -e "using Pkg; Pkg.instantiate()"
cd ..
```

### Step 2: Install Frontend Dependencies (2 min)
```bash
cd web
npm install
cd ..
```

### Step 3: Start Backend (Terminal 1)
```bash
cd api
julia --project=. -e "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"
```

Wait for: `Starting Game of Life API server on port 8000...`

### Step 4: Start Frontend (Terminal 2)
```bash
cd web
npm run dev
```

Wait for: `- Local: http://localhost:3000`

### Step 5: Play! 🎮
Open browser to: **http://localhost:3000**

---

## 🎮 How to Play

1. **Select a pattern** from the left panel
2. **Click on the right side** (blue zone) to place it
3. **Watch enemies** spawn from the left (red zone)
4. **Destroy enemies** by placing patterns in their path
5. **Earn points** for each enemy destroyed
6. **Game over** when 5+ enemies escape

---

## 📊 Game Stats

| Metric | Value |
|--------|-------|
| Grid Size | 200x200 |
| Enemy Zone | Left half (columns 1-100) |
| Player Zone | Right half (columns 101-200) |
| Points per Kill | +10 |
| Points per Escape | -5 |
| Game Over | 5+ escaped |

---

## 🎯 Patterns

- **Glider** - Moves diagonally
- **Blinker** - Oscillates (period 2)
- **Toad** - Oscillates (period 2)
- **Beacon** - Oscillates (period 2)

---

## ⚙️ Controls

| Control | Action |
|---------|--------|
| Select Pattern | Click pattern button |
| Place Pattern | Click on grid (right side) |
| Play/Pause | Click Play/Pause button |
| Speed | Select Slow/Normal/Fast |
| Restart | Click Restart button |

---

## 🐛 Troubleshooting

**API not connecting?**
- Ensure Julia API is running on port 8000
- Check `.env.local` in web folder

**Grid not showing?**
- Refresh browser (Ctrl+R)
- Check browser console (F12)

**Port already in use?**
- Change port in api/src/api.jl
- Or kill process using the port

---

## 📚 Full Documentation

- **Setup Guide:** See `SETUP.md`
- **Full Documentation:** See `FULLSTACK_README.md`
- **Backend Code:** See `api/src/`
- **Frontend Code:** See `web/components/`

---

## 🎉 You're Ready!

The game is now running. Have fun defending against the incoming patterns! 🚀

**Tips:**
- Start with Slow speed to learn
- Watch enemy patterns to predict their path
- Use oscillating patterns to create barriers
- Try to get on the leaderboard!

---

**Enjoy! 🎮**
