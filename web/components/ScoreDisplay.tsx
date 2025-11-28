'use client';

import React from 'react';
import { GameState } from '@/types/game';

interface ScoreDisplayProps {
  gameState: GameState;
}

export default function ScoreDisplay({ gameState }: ScoreDisplayProps) {
  const { score, generation, stats } = gameState;

  return (
    <div className="card">
      <h3 className="text-lg font-bold mb-4">Game Stats</h3>
      
      <div className="space-y-3">
        <div className="flex justify-between items-center">
          <span className="text-gray-400">Score:</span>
          <span className="text-2xl font-bold text-green-400">{score}</span>
        </div>

        <div className="flex justify-between items-center">
          <span className="text-gray-400">Generation:</span>
          <span className="text-xl font-semibold">{generation}</span>
        </div>

        <div className="flex justify-between items-center">
          <span className="text-gray-400">Wave:</span>
          <span className="text-xl font-semibold">{stats.wave}</span>
        </div>

        <hr className="border-gray-700" />

        <div className="flex justify-between items-center">
          <span className="text-gray-400">Destroyed:</span>
          <span className="text-lg font-semibold text-blue-400">
            {stats.patternsDestroyed}
          </span>
        </div>

        <div className="flex justify-between items-center">
          <span className="text-gray-400">Escaped:</span>
          <span className="text-lg font-semibold text-red-400">
            {stats.enemiesEscaped}
          </span>
        </div>

        {stats.enemiesEscaped >= 3 && (
          <div className="mt-4 p-2 bg-red-900 bg-opacity-30 rounded text-red-300 text-sm">
            ⚠ Warning: {5 - stats.enemiesEscaped} enemies until game over!
          </div>
        )}
      </div>
    </div>
  );
}
