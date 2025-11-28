# Game of Life - Full Stack Web Game

A complete full-stack implementation of an interactive Game of Life web game where players defend against incoming spaceships and gliders on a 200x200 grid.

## 🎮 Game Overview

**Objective:** Defend the right side of the grid by placing defensive patterns to intercept and destroy incoming enemy patterns from the left side.

**Mechanics:**
- Enemy patterns spawn on the left side and move toward the right
- Players place defensive patterns on the right side
- Collisions between patterns destroy both and earn points
- Game over when 5+ enemies escape to the right edge
- Difficulty increases as you progress through waves

## 🏗️ Architecture

### Backend (Julia API)
- **Framework:** HTTP.jl
- **Port:** 8000
- **Features:**
  - 200x200 grid simulation
  - Game of Life rules implementation
  - Enemy spawning with difficulty scaling
  - Collision detection and scoring
  - Session management
  - REST API endpoints

### Frontend (Next.js)
- **Framework:** Next.js 14+ with TypeScript
- **Styling:** Tailwind CSS
- **Features:**
  - Real-time game visualization
  - Interactive pattern placement
  - Game controls (play/pause, speed, restart)
  - Score tracking and statistics
  - High score leaderboard
  - Responsive design (desktop, tablet, mobile)
  - Game over modal with name entry

## 📋 Project Structure

```
game-of-life-web/
├── api/                          # Julia Backend
│   ├── Project.toml
│   └── src/
│       ├── GameOfLifeAPI.jl      # Main module
│       ├── game_session.jl       # Session management
│       ├── game_logic.jl         # Game rules & logic
│       └── api.jl                # REST endpoints
│
├── web/                          # Next.js Frontend
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx              # Main game page
│   │   └── globals.css
│   ├── components/
│   │   ├── GameCanvas.tsx        # Grid visualization
│   │   ├── PatternSelector.tsx   # Pattern selection
│   │   ├── GameControls.tsx      # Play/pause/speed
│   │   ├── ScoreDisplay.tsx      # Stats display
│   │   ├── Leaderboard.tsx       # High scores
│   │   └── GameOverModal.tsx     # Game over screen
│   ├── hooks/
│   │   └── useGameState.ts       # Game state management
│   ├── types/
│   │   └── game.ts               # TypeScript types
│   ├── utils/
│   │   ├── api.ts                # API client
│   │   └── storage.ts            # LocalStorage utilities
│   ├── package.json
│   ├── tsconfig.json
│   ├── tailwind.config.ts
│   └── next.config.js
│
├── FULLSTACK_README.md           # This file
└── SETUP.md                      # Setup instructions
```

## 🚀 Quick Start

### Prerequisites
- Julia 1.6+ ([Download](https://julialang.org/downloads/))
- Node.js 18+ ([Download](https://nodejs.org/))
- npm or yarn

### Backend Setup

1. **Navigate to API directory:**
   ```bash
   cd api
   ```

2. **Install Julia dependencies:**
   ```bash
   julia --project=. -e "using Pkg; Pkg.instantiate()"
   ```

3. **Start the API server:**
   ```bash
   julia --project=. -e "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"
   ```

   The API will be available at `http://localhost:8000`

### Frontend Setup

1. **Navigate to web directory:**
   ```bash
   cd web
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Create environment file:**
   ```bash
   cp .env.example .env.local
   ```

4. **Start development server:**
   ```bash
   npm run dev
   ```

   The frontend will be available at `http://localhost:3000`

## 🎮 How to Play

### Game Controls
- **Select Pattern:** Click on a pattern in the "Select Defensive Pattern" section
- **Place Pattern:** Click on the right side (blue zone) of the grid to place the selected pattern
- **Play/Pause:** Use the Play/Pause button to control the game
- **Speed:** Adjust game speed (Slow, Normal, Fast)
- **Restart:** Start a new game

### Scoring
- **+10 points:** For each enemy pattern destroyed
- **-5 points:** For each enemy that escapes to the right edge
- **Game Over:** When 5+ enemies escape

### Patterns
- **Glider:** Moves diagonally across the grid
- **Blinker:** Oscillates between horizontal and vertical (period 2)
- **Toad:** Oscillates in place (period 2)
- **Beacon:** Oscillates in place (period 2)

## 🔌 API Endpoints

### Game Management
```
POST /api/game/new
  Request: { difficulty: "normal" | "easy" | "hard" }
  Response: GameState

GET /api/game/:gameId/state
  Response: GameState

POST /api/game/:gameId/restart
  Response: GameState
```

### Game Actions
```
POST /api/game/:gameId/step
  Response: { success: bool, generation: int, score: int, ... }

POST /api/game/:gameId/place-pattern
  Request: { pattern: string, row: int, col: int }
  Response: { success: bool, grid: number[][], ... }

POST /api/game/:gameId/pause
  Request: { paused: bool }
  Response: { success: bool, paused: bool }

POST /api/game/:gameId/set-speed
  Request: { speed: "slow" | "normal" | "fast" }
  Response: { success: bool, speed: string }
```

## 📊 Game State

```typescript
interface GameState {
  gameId: string;
  grid: number[][];  // 200x200 grid (0 = dead, 1 = alive)
  score: number;
  generation: number;
  paused: boolean;
  speed: "slow" | "normal" | "fast";
  gameOver: boolean;
  stats: {
    patternsDestroyed: number;
    enemiesEscaped: number;
    wave: number;
  };
}
```

## 🎨 Customization

### Colors
Edit `web/tailwind.config.ts` to customize colors:
```typescript
colors: {
  alive: '#10b981',      // Green for alive cells
  dead: '#1f2937',       // Dark gray for dead cells
  enemy: '#ef4444',      // Red for enemy zone
  player: '#3b82f6',     // Blue for player zone
}
```

### Game Difficulty
Modify `api/src/game_logic.jl` to adjust:
- Enemy spawn rates
- Pattern types
- Scoring multipliers
- Game over conditions

### Grid Size
To change grid size, modify:
- `api/src/game_session.jl`: `GameSession` struct initialization
- `web/components/GameCanvas.tsx`: `GRID_SIZE` constant
- `web/types/game.ts`: Update grid dimensions

## 🧪 Testing

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

## 📦 Deployment

### Backend Deployment (Julia API)
1. **Docker:**
   ```dockerfile
   FROM julia:1.12
   WORKDIR /app
   COPY api .
   RUN julia --project=. -e "using Pkg; Pkg.instantiate()"
   EXPOSE 8000
   CMD ["julia", "--project=.", "-e", "using GameOfLifeAPI; GameOfLifeAPI.start_server(8000)"]
   ```

2. **Cloud Platforms:**
   - Heroku
   - AWS Lambda
   - DigitalOcean App Platform
   - Railway

### Frontend Deployment (Next.js)
1. **Vercel (Recommended):**
   ```bash
   npm install -g vercel
   vercel
   ```

2. **Other Platforms:**
   ```bash
   npm run build
   npm start
   ```

## 🔧 Development

### Adding New Patterns
1. Add pattern definition in `api/src/game_logic.jl`
2. Update `get_pattern()` function
3. Add pattern to `PATTERNS` array in `web/components/PatternSelector.tsx`

### Modifying Game Rules
Edit `apply_game_of_life_rules()` in `api/src/game_logic.jl`

### Changing UI Layout
Edit components in `web/components/` and `web/app/page.tsx`

## 🐛 Troubleshooting

### API Connection Error
- Ensure Julia API is running on port 8000
- Check `NEXT_PUBLIC_API_URL` in `.env.local`
- Verify CORS is enabled in API

### Grid Not Updating
- Check browser console for errors
- Verify game is not paused
- Restart the game

### Performance Issues
- Reduce grid size
- Lower game speed
- Check browser performance tab

## 📚 Resources

- [Julia Documentation](https://docs.julialang.org/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 🎯 Future Enhancements

- [ ] Multiplayer mode
- [ ] Power-ups and special abilities
- [ ] Custom pattern creation
- [ ] Replay system
- [ ] Achievements/badges
- [ ] Sound effects and music
- [ ] Mobile app version
- [ ] AI opponent mode
- [ ] Pattern library/sharing
- [ ] Advanced statistics

---

**Enjoy the Game of Life! 🎮**
