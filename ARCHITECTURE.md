# Architecture Overview - Game of Life Web Game

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Web Browser                             │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              Next.js Frontend (Port 3000)                 │  │
│  │                                                           │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │              React Components                       │ │  │
│  │  │  ┌──────────────┐  ┌──────────────┐               │ │  │
│  │  │  │ GameCanvas   │  │ PatternSel   │               │ │  │
│  │  │  └──────────────┘  └──────────────┘               │ │  │
│  │  │  ┌──────────────┐  ┌──────────────┐               │ │  │
│  │  │  │GameControls  │  │ScoreDisplay  │               │ │  │
│  │  │  └──────────────┘  └──────────────┘               │ │  │
│  │  │  ┌──────────────┐  ┌──────────────┐               │ │  │
│  │  │  │Leaderboard   │  │GameOverModal │               │ │  │
│  │  │  └──────────────┘  └──────────────┘               │ │  │
│  │  └─────────────────────────────────────────────────────┘ │  │
│  │                                                           │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │         useGameState Hook                           │ │  │
│  │  │  - Game state management                            │ │  │
│  │  │  - API communication                                │ │  │
│  │  │  - Game loop (requestAnimationFrame)                │ │  │
│  │  └─────────────────────────────────────────────────────┘ │  │
│  │                                                           │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │         Utils & Storage                             │ │  │
│  │  │  - API client (api.ts)                              │ │  │
│  │  │  - LocalStorage (storage.ts)                        │ │  │
│  │  │  - Types (game.ts)                                  │ │  │
│  │  └─────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                    HTTP/JSON
                         │
┌────────────────────────▼─────────────────────────────────────────┐
│              Julia Backend API (Port 8000)                       │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           REST API Endpoints                              │  │
│  │  ┌──────────────────────────────────────────────────────┐ │  │
│  │  │ POST   /api/game/new                                │ │  │
│  │  │ GET    /api/game/:id/state                          │ │  │
│  │  │ POST   /api/game/:id/step                           │ │  │
│  │  │ POST   /api/game/:id/place-pattern                  │ │  │
│  │  │ POST   /api/game/:id/pause                          │ │  │
│  │  │ POST   /api/game/:id/restart                        │ │  │
│  │  │ POST   /api/game/:id/set-speed                      │ │  │
│  │  └──────────────────────────────────────────────────────┘ │  │
│  │                                                           │  │
│  │  ┌──────────────────────────────────────────────────────┐ │  │
│  │  │         Game Logic Module                            │ │  │
│  │  │  - Game of Life rules                                │ │  │
│  │  │  - Enemy spawning                                    │ │  │
│  │  │  - Collision detection                               │ │  │
│  │  │  - Scoring system                                    │ │  │
│  │  └──────────────────────────────────────────────────────┘ │  │
│  │                                                           │  │
│  │  ┌──────────────────────────────────────────────────────┐ │  │
│  │  │         Game Session Management                      │ │  │
│  │  │  - Session storage (Dict)                            │ │  │
│  │  │  - Grid state (200x200 Matrix{Bool})                 │ │  │
│  │  │  - Score tracking                                    │ │  │
│  │  │  - Generation counter                                │ │  │
│  │  └──────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Game Initialization
```
User Opens Browser
    ↓
Frontend loads (Next.js)
    ↓
useGameState hook initializes
    ↓
POST /api/game/new
    ↓
Backend creates GameSession
    ↓
Returns initial GameState
    ↓
Frontend renders GameCanvas
```

### Game Loop
```
User clicks Play
    ↓
Game loop starts (every 100-500ms based on speed)
    ↓
POST /api/game/:id/step
    ↓
Backend:
  - Applies Game of Life rules
  - Spawns enemies
  - Detects collisions
  - Updates score
    ↓
Returns updated grid & score
    ↓
Frontend updates visualization
    ↓
Repeat
```

### Pattern Placement
```
User selects pattern
    ↓
User clicks on grid (right zone)
    ↓
Frontend calls placePattern()
    ↓
POST /api/game/:id/place-pattern
    ↓
Backend validates placement
    ↓
Places pattern on grid
    ↓
Returns updated grid
    ↓
Frontend updates visualization
```

## Component Hierarchy

```
App (page.tsx)
├── GameCanvas
│   └── Grid cells (200x200)
├── PatternSelector
│   └── Pattern buttons (4)
├── GameControls
│   ├── Play/Pause button
│   ├── Speed selector
│   └── Restart button
├── ScoreDisplay
│   ├── Score
│   ├── Generation
│   ├── Wave
│   ├── Destroyed count
│   └── Escaped count
├── Leaderboard
│   └── High scores list
└── GameOverModal
    ├── Final score
    ├── Name input
    └── Restart button
```

## State Management

### Frontend State (React)
```typescript
GameState {
  gameId: string
  grid: number[][]
  score: number
  generation: number
  paused: boolean
  speed: "slow" | "normal" | "fast"
  gameOver: boolean
  stats: {
    patternsDestroyed: number
    enemiesEscaped: number
    wave: number
  }
}
```

### Backend State (Julia)
```julia
GameSession {
  id: String
  grid: Matrix{Bool}  # 200x200
  score: Int
  generation: Int
  paused: Bool
  speed: String
  patterns_destroyed: Int
  enemies_escaped: Int
  game_over: Bool
  difficulty: String
  last_spawn: Int
  spawn_interval: Int
}
```

## Grid Layout

```
┌─────────────────────────────────────────┐
│  Enemy Zone (Left)  │  Player Zone (Right)
│  Columns 1-100      │  Columns 101-200
│                     │
│  Red Border         │  Blue Border
│                     │
│  Enemies spawn      │  Player places
│  and move right     │  defensive patterns
│                     │
│  200 rows total     │
└─────────────────────────────────────────┘
```

## API Request/Response Flow

### Create Game
```
Request:
POST /api/game/new
{
  "difficulty": "normal"
}

Response:
{
  "gameId": "uuid",
  "grid": [[0,1,0,...], ...],
  "score": 0,
  "generation": 0,
  "paused": false,
  "speed": "normal",
  "gameOver": false,
  "stats": {
    "patternsDestroyed": 0,
    "enemiesEscaped": 0,
    "wave": 1
  }
}
```

### Step Game
```
Request:
POST /api/game/:gameId/step

Response:
{
  "success": true,
  "generation": 1,
  "score": 10,
  "collisions": 1,
  "escaped": 0,
  "grid": [[0,1,0,...], ...]
}
```

### Place Pattern
```
Request:
POST /api/game/:gameId/place-pattern
{
  "pattern": "glider",
  "row": 100,
  "col": 150
}

Response:
{
  "success": true,
  "message": "Pattern placed successfully",
  "grid": [[0,1,0,...], ...]
}
```

## Performance Considerations

### Frontend
- **Rendering:** Only update changed cells
- **State Updates:** Debounce API calls
- **Memory:** Efficient grid storage
- **Network:** Minimize API requests

### Backend
- **Computation:** < 50ms per generation
- **Memory:** Efficient Matrix storage
- **Concurrency:** Handle multiple sessions
- **Caching:** Pre-compute patterns

## Deployment Architecture

```
┌─────────────────────────────────────────┐
│         Production Environment          │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Frontend (Vercel/Netlify)      │   │
│  │  - Next.js build                │   │
│  │  - Static assets                │   │
│  │  - CDN distribution             │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Backend (Docker/Cloud)         │   │
│  │  - Julia API container          │   │
│  │  - Load balancer                │   │
│  │  - Session persistence          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Database (Optional)            │   │
│  │  - High scores                  │   │
│  │  - Game history                 │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

## Technology Stack Diagram

```
Frontend Layer
├── React 18
├── TypeScript
├── Next.js 14
├── Tailwind CSS
└── React Hooks

API Layer
├── HTTP.jl
├── JSON.jl
└── CORS

Backend Layer
├── Julia 1.6+
├── Game Logic
├── Session Management
└── Pattern Library

Storage Layer
├── Browser LocalStorage (Frontend)
└── In-Memory Dict (Backend)
```

## Security Architecture

```
┌─────────────────────────────────────────┐
│         Security Layers                 │
├─────────────────────────────────────────┤
│                                         │
│  Input Validation                       │
│  ├── Pattern validation                 │
│  ├── Coordinate validation              │
│  └── Session ID validation              │
│                                         │
│  Error Handling                         │
│  ├── Try-catch blocks                   │
│  ├── Error responses                    │
│  └── Logging                            │
│                                         │
│  CORS Configuration                     │
│  ├── Allow frontend origin              │
│  ├── Allowed methods                    │
│  └── Allowed headers                    │
│                                         │
│  Session Management                     │
│  ├── UUID generation                    │
│  ├── Session validation                 │
│  └── Timeout handling                   │
│                                         │
└─────────────────────────────────────────┘
```

---

**Architecture designed for scalability, maintainability, and performance.**
