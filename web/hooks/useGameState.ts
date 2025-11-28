'use client';

import { useState, useEffect, useCallback, useRef } from 'react';
import { GameState, PatternName, Speed } from '@/types/game';
import * as api from '@/utils/api';

const SPEED_INTERVALS = {
  slow: 500,
  normal: 200,
  fast: 100,
};

export function useGameState() {
  const [gameState, setGameState] = useState<GameState | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const gameLoopRef = useRef<NodeJS.Timeout | null>(null);

  // Initialize game
  useEffect(() => {
    const initGame = async () => {
      try {
        setLoading(true);
        const state = await api.createGame('normal');
        setGameState(state);
        setError(null);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to create game');
      } finally {
        setLoading(false);
      }
    };

    initGame();
  }, []);

  // Game loop
  useEffect(() => {
    if (!gameState || gameState.paused || gameState.gameOver) {
      if (gameLoopRef.current) {
        clearInterval(gameLoopRef.current);
        gameLoopRef.current = null;
      }
      return;
    }

    const interval = SPEED_INTERVALS[gameState.speed];

    gameLoopRef.current = setInterval(async () => {
      try {
        const result = await api.stepGame(gameState.gameId);
        if (result.success) {
          const updatedState = await api.getGameState(gameState.gameId);
          setGameState(updatedState);
        }
      } catch (err) {
        console.error('Game loop error:', err);
      }
    }, interval);

    return () => {
      if (gameLoopRef.current) {
        clearInterval(gameLoopRef.current);
      }
    };
  }, [gameState?.paused, gameState?.speed, gameState?.gameId, gameState?.gameOver]);

  const placePattern = useCallback(
    async (pattern: PatternName, row: number, col: number) => {
      if (!gameState) return;

      try {
        const result = await api.placePattern(gameState.gameId, {
          pattern,
          row,
          col,
        });

        if (result.success) {
          const updatedState = await api.getGameState(gameState.gameId);
          setGameState(updatedState);
        } else {
          setError(result.error || 'Failed to place pattern');
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to place pattern');
      }
    },
    [gameState]
  );

  const togglePause = useCallback(async () => {
    if (!gameState) return;

    try {
      await api.pauseGame(gameState.gameId, !gameState.paused);
      const updatedState = await api.getGameState(gameState.gameId);
      setGameState(updatedState);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to toggle pause');
    }
  }, [gameState]);

  const restart = useCallback(async () => {
    if (!gameState) return;

    try {
      const newState = await api.restartGame(gameState.gameId);
      setGameState(newState);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to restart game');
    }
  }, [gameState]);

  const setSpeed = useCallback(
    async (speed: Speed) => {
      if (!gameState) return;

      try {
        await api.setSpeed(gameState.gameId, speed);
        setGameState({ ...gameState, speed });
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to set speed');
      }
    },
    [gameState]
  );

  return {
    gameState,
    loading,
    error,
    placePattern,
    togglePause,
    restart,
    setSpeed,
  };
}
