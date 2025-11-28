'use client';

import React, { useEffect, useState } from 'react';
import { HighScore } from '@/types/game';
import { getHighScores, clearHighScores } from '@/utils/storage';

export default function Leaderboard() {
  const [scores, setScores] = useState<HighScore[]>([]);

  useEffect(() => {
    setScores(getHighScores());
  }, []);

  const handleClear = () => {
    if (confirm('Are you sure you want to clear all high scores?')) {
      clearHighScores();
      setScores([]);
    }
  };

  return (
    <div className="card">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-lg font-bold">🏆 High Scores</h3>
        {scores.length > 0 && (
          <button
            onClick={handleClear}
            className="text-xs text-red-400 hover:text-red-300"
          >
            Clear
          </button>
        )}
      </div>

      {scores.length === 0 ? (
        <p className="text-gray-400 text-center py-4">No high scores yet. Play to get on the board!</p>
      ) : (
        <div className="space-y-2">
          {scores.map((score, idx) => (
            <div
              key={idx}
              className="flex justify-between items-center p-2 bg-gray-700 bg-opacity-50 rounded"
            >
              <div className="flex items-center gap-3">
                <span className="text-lg font-bold text-yellow-400 w-6">
                  {idx + 1}
                </span>
                <span className="font-semibold">{score.name}</span>
              </div>
              <span className="text-green-400 font-bold">{score.score}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
