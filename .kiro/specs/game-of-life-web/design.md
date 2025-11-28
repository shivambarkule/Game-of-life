# Game of Life Web Game - Design Document

## Overview

The Game of Life Web Game is a full-stack application combining a Julia backend API with a Next.js frontend. Players defend against incoming spaceships and gliders by placing defensive patterns on a 200x200 grid. The backend handles all game simulation logic while the frontend provides an interactive, responsive user interface with real-time visualization.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Web Browser                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Next.js Frontend (TypeScript + Tailwind CSS)    │   │
│  │  - Game visualization                            │   │
│  │  - Player controls                               │   │
│  │  - Score/stats display                           │   │
│  │  - Leaderboard                                   │   │
│  └──────────────────────────────────────────────────┘   │
└────────────────────┬─────────────────────────────────────┘
                     │ HTTP/WebSocket
                     │
┌────────────────────▼─────────────────────────────────────┐
│              Julia Backend API                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Game Simulation Engine                          │   │
│  │  - Grid management (200x200)                     │   │
│  │  - Game of Life rules                            │   │
│  │  - Enemy spawning logic                          │   │
│  │  - Collision detection                           │   │
│  │  - Score calculation                             │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  REST API Endpoints                              │   │
│  │  - POST /game/new                                │   │
│  │  - POST /game/:id/step                           │   │
│  │  - POST /game/:id/place-pattern                  │   │
│  │  - GET /game/:id/state                           │   │
│  │  - POST /game/:id/pause                          │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### Frontend Components (Next.js + TypeScript)

#### 1. Game Canvas Component
- Renders 200x200 grid with cells
- Color-coded zones (enemy left, player right)
- Real-time cell updates
- Responsive sizing

#### 2. Pattern Selector Component
- Displays available patterns (glider, blinker, toad, beacon)
- Pattern preview
- Selection state management
- Placement mode indicator

#### 3. Game Controls Component
- Play/Pause button
- Speed selector (slow, normal, fast)
- Restart button
- Settings panel

#### 4. Score Display Component
- Current score
- Patterns destroyed count
- Enemy patterns escaped count
- Wave/level number
- Generation counter

#### 5. Leaderboard Component
- Top 10 high scores
- Player names
- Score values
- Timestamps
- Clear scores button

#### 6. Game Over Modal
- Final score
- Statistics summary
- Name entry for high score
- Restart button

### Backend API Endpoints (Julia)

#### Game Session Management
```
POST /api/game/new
  Request: { difficulty: "normal" }
  Response: { gameId: string, grid: number[][], score: 0, generation: 0 }

GET /api/game/:gameId/state
  Response: { grid: number[][], score: number, generation: number, gameOver: boolean, stats: {...} }

POST /api/game/:gameId/pause
  Request: { paused: boolean }
  Response: { paused: boolean }

POST /api/game/:gameId/restart
  Response: { gameId: string, grid: number[][], score: 0 }
```

#### Game Actions
```
POST /api/game/:gameId/step
  Request: { speed: "normal" }
  Response: { grid: number[][], score: number, generation: number, collisions: number }

POST /api/game/:gameId/place-pattern
  Request: { pattern: "glider", row: number, col: number }
  Response: { success: boolean, grid: number[][], message: string }

POST /api/game/:gameId/set-speed
  Request: { speed: "slow" | "normal" | "fast" }
  Response: { speed: string }
```

### Data Models

#### Game State
```julia
mutable struct GameSession
    id::String
    grid::Grid  # 200x200
    enemy_zone::Matrix{Bool}  # Left half
    player_zone::Matrix{Bool}  # Right half
    score::Int
    generation::Int
    paused::Bool
    speed::String  # "slow", "normal", "fast"
    enemy_patterns::Vector{Tuple{Int, Int, String}}  # (row, col, type)
    player_patterns::Vector{Tuple{Int, Int, String}}
    patterns_destroyed::Int
    enemies_escaped::Int
    game_over::Bool
    difficulty::String
end
```

#### Frontend Game State (TypeScript)
```typescript
interface GameState {
  gameId: string;
  grid: number[][];  // 0 = dead, 1 = alive
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

interface Pattern {
  name: "glider" | "blinker" | "toad" | "beacon";
  grid: number[][];
  width: number;
  height: number;
}
```

## Game Mechanics

### Enemy Spawning
- Enemies spawn randomly on left edge (columns 1-10)
- Spawn rate increases with difficulty/wave
- Random pattern selection (glider, blinker, toad)
- Gliders move diagonally right
- Blinkers oscillate in place
- Toads oscillate in place

### Collision Detection
- Check for overlapping alive cells between enemy and player patterns
- When collision detected:
  - Remove both patterns
  - Award points (10 points per enemy destroyed)
  - Increment patterns_destroyed counter
  - Trigger visual effect

### Scoring System
- Enemy destroyed: +10 points
- Enemy escaped (reached right edge): -5 points
- Bonus for destroying multiple enemies in one generation: +5 per extra

### Difficulty Scaling
- Wave 1: Spawn every 15 generations
- Wave 2: Spawn every 12 generations
- Wave 3: Spawn every 10 generations
- Wave 4+: Spawn every 8 generations
- Game over when 5+ enemies escape

### Game Over Conditions
- Too many enemies escaped (5+)
- Player chooses to restart

## Frontend Architecture (Next.js)

### Project Structure
```
game-of-life-web/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── api/
│       └── game/
│           ├── route.ts
│           └── [gameId]/
│               └── route.ts
├── components/
│   ├── GameCanvas.tsx
│   ├── PatternSelector.tsx
│   ├── GameControls.tsx
│   ├── ScoreDisplay.tsx
│   ├── Leaderboard.tsx
│   └── GameOverModal.tsx
├── hooks/
│   ├── useGameState.ts
│   └── useLocalStorage.ts
├── types/
│   └── game.ts
├── utils/
│   ├── api.ts
│   └── gameLogic.ts
├── styles/
│   └── globals.css
└── public/
    └── sounds/
```

### Key Technologies
- **Next.js 14+**: React framework with App Router
- **TypeScript**: Type-safe development
- **Tailwind CSS**: Utility-first styling
- **React Hooks**: State management
- **Fetch API**: Backend communication
- **LocalStorage**: High score persistence

## Backend Architecture (Julia)

### Project Structure
```
game-of-life-api/
├── src/
│   ├── GameOfLife.jl
│   ├── game_session.jl
│   ├── game_logic.jl
│   ├── api.jl
│   └── utils.jl
├── Project.toml
└── test/
```

### Key Technologies
- **HTTP.jl**: Web server
- **JSON.jl**: JSON serialization
- **UUIDs.jl**: Session ID generation
- **Dates.jl**: Timestamp tracking

## Performance Considerations

### Frontend
- Canvas rendering optimization (only update changed cells)
- Debounce pattern placement requests
- Lazy load leaderboard
- Memoize pattern components

### Backend
- Cache grid computations
- Use efficient neighbor counting
- Batch collision detection
- Connection pooling for concurrent sessions
- Target: < 50ms per generation for 200x200 grid

## Error Handling

### Frontend
- Network error recovery with retry
- Invalid pattern placement feedback
- Session timeout handling
- Graceful degradation

### Backend
- Input validation for all endpoints
- Session not found errors
- Invalid pattern placement errors
- Grid boundary validation
- Concurrent modification handling

## Security Considerations

- Validate all player inputs on backend
- Sanitize pattern placement coordinates
- Rate limit API endpoints
- Session ID validation
- CORS configuration

## Testing Strategy

### Frontend Tests
- Component rendering tests
- Game state management tests
- API integration tests
- LocalStorage tests
- Responsive design tests

### Backend Tests
- Game logic tests
- Collision detection tests
- Enemy spawning tests
- API endpoint tests
- Performance benchmarks

## Deployment

### Frontend
- Deploy to Vercel (Next.js native)
- Environment variables for API URL
- CDN for static assets

### Backend
- Deploy Julia API to cloud (AWS, Heroku, DigitalOcean)
- Docker containerization
- Environment configuration
- Health check endpoints

## Future Enhancements

- Multiplayer mode (competitive)
- Power-ups and special abilities
- Custom pattern creation
- Replay system
- Achievements/badges
- Sound effects and music
- Mobile app version
- AI opponent mode
