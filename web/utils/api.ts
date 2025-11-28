import { GameState, PlacementRequest } from '@/types/game';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

export async function createGame(difficulty: string = 'normal'): Promise<GameState> {
  const response = await fetch(`${API_URL}/api/game/new`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ difficulty }),
  });
  
  if (!response.ok) throw new Error('Failed to create game');
  return response.json();
}

export async function getGameState(gameId: string): Promise<GameState> {
  const response = await fetch(`${API_URL}/api/game/${gameId}/state`);
  
  if (!response.ok) throw new Error('Failed to get game state');
  return response.json();
}

export async function stepGame(gameId: string): Promise<any> {
  const response = await fetch(`${API_URL}/api/game/${gameId}/step`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
  });
  
  if (!response.ok) throw new Error('Failed to step game');
  return response.json();
}

export async function placePattern(
  gameId: string,
  request: PlacementRequest
): Promise<any> {
  const response = await fetch(`${API_URL}/api/game/${gameId}/place-pattern`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(request),
  });
  
  if (!response.ok) throw new Error('Failed to place pattern');
  return response.json();
}

export async function pauseGame(gameId: string, paused: boolean): Promise<any> {
  const response = await fetch(`${API_URL}/api/game/${gameId}/pause`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ paused }),
  });
  
  if (!response.ok) throw new Error('Failed to pause game');
  return response.json();
}

export async function restartGame(gameId: string): Promise<GameState> {
  const response = await fetch(`${API_URL}/api/game/${gameId}/restart`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
  });
  
  if (!response.ok) throw new Error('Failed to restart game');
  return response.json();
}

export async function setSpeed(gameId: string, speed: string): Promise<any> {
  const response = await fetch(`${API_URL}/api/game/${gameId}/set-speed`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ speed }),
  });
  
  if (!response.ok) throw new Error('Failed to set speed');
  return response.json();
}
