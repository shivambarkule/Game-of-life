import { HighScore } from '@/types/game';

const HIGH_SCORES_KEY = 'gameOfLife_highScores';

export function getHighScores(): HighScore[] {
  if (typeof window === 'undefined') return [];
  
  try {
    const scores = localStorage.getItem(HIGH_SCORES_KEY);
    return scores ? JSON.parse(scores) : [];
  } catch {
    return [];
  }
}

export function saveHighScore(name: string, score: number): void {
  if (typeof window === 'undefined') return;
  
  try {
    const scores = getHighScores();
    scores.push({ name, score, timestamp: Date.now() });
    scores.sort((a, b) => b.score - a.score);
    const topScores = scores.slice(0, 10);
    localStorage.setItem(HIGH_SCORES_KEY, JSON.stringify(topScores));
  } catch {
    console.error('Failed to save high score');
  }
}

export function clearHighScores(): void {
  if (typeof window === 'undefined') return;
  
  try {
    localStorage.removeItem(HIGH_SCORES_KEY);
  } catch {
    console.error('Failed to clear high scores');
  }
}
