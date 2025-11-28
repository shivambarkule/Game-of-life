export type PatternName = 'glider' | 'blinker' | 'toad' | 'beacon';
export type Speed = 'slow' | 'normal' | 'fast';
export type Difficulty = 'easy' | 'normal' | 'hard';

export interface GameState {
  gameId: string;
  grid: number[][];
  score: number;
  generation: number;
  paused: boolean;
  speed: Speed;
  gameOver: boolean;
  stats: {
    patternsDestroyed: number;
    enemiesEscaped: number;
    wave: number;
  };
}

export interface Pattern {
  name: PatternName;
  grid: number[][];
  width: number;
  height: number;
}

export interface HighScore {
  name: string;
  score: number;
  timestamp: number;
}

export interface PlacementRequest {
  pattern: PatternName;
  row: number;
  col: number;
}
