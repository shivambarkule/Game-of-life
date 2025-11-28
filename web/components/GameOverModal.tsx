'use client';

import React, { useState } from 'react';
import { GameState } from '@/types/game';
import { saveHighScore } from '@/utils/storage';

interface GameOverModalProps {
  gameState: GameState;
  onRestart: () => void;
  onClose: () => void;
}

export default function GameOverModal({
  gameState,
  onRestart,
  onClose,
}: GameOverModalProps) {
  const [playerName, setPlayerName] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    if (playerName.trim()) {
      saveHighScore(playerName, gameState.score);
      setSubmitted(true);
    }
  };

  if (!gameState.gameOver) return null;

  return (
    <div className="modal-overlay">
      <div className="modal">
        <h2 className="text-2xl font-bold mb-4 text-center">Game Over!</h2>

        <div className="space-y-4 mb-6">
          <div className="text-center">
            <p className="text-gray-400 text-sm">Final Score</p>
            <p className="text-4xl font-bold text-green-400">{gameState.score}</p>
          </div>

          <div className="grid grid-cols-2 gap-4 text-sm">
            <div className="text-center">
              <p className="text-gray-400">Destroyed</p>
              <p className="text-xl font-semibold text-blue-400">
                {gameState.stats.patternsDestroyed}
              </p>
            </div>
            <div className="text-center">
              <p className="text-gray-400">Escaped</p>
              <p className="text-xl font-semibold text-red-400">
                {gameState.stats.enemiesEscaped}
              </p>
            </div>
          </div>
        </div>

        {!submitted ? (
          <div className="space-y-3 mb-4">
            <input
              type="text"
              placeholder="Enter your name"
              value={playerName}
              onChange={(e) => setPlayerName(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSubmit()}
              className="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
              maxLength={20}
            />
            <button
              onClick={handleSubmit}
              className="btn btn-primary w-full"
            >
              Save Score
            </button>
          </div>
        ) : (
          <div className="mb-4 p-3 bg-green-900 bg-opacity-30 rounded text-green-300 text-center text-sm">
            ✓ Score saved!
          </div>
        )}

        <button
          onClick={onRestart}
          className="btn btn-secondary w-full"
        >
          Play Again
        </button>
      </div>
    </div>
  );
}
