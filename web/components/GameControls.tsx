'use client';

import React from 'react';
import { Speed } from '@/types/game';

interface GameControlsProps {
  paused: boolean;
  speed: Speed;
  gameOver: boolean;
  onPlayPause: () => void;
  onRestart: () => void;
  onSpeedChange: (speed: Speed) => void;
}

export default function GameControls({
  paused,
  speed,
  gameOver,
  onPlayPause,
  onRestart,
  onSpeedChange,
}: GameControlsProps) {
  return (
    <div className="card">
      <h3 className="text-lg font-bold mb-4">Game Controls</h3>
      
      <div className="space-y-4">
        {/* Play/Pause */}
        <button
          onClick={onPlayPause}
          disabled={gameOver}
          className="btn btn-primary w-full"
        >
          {paused ? '▶ Play' : '⏸ Pause'}
        </button>

        {/* Speed Control */}
        <div>
          <label className="block text-sm font-semibold mb-2">Speed</label>
          <div className="grid grid-cols-3 gap-2">
            {(['slow', 'normal', 'fast'] as const).map((s) => (
              <button
                key={s}
                onClick={() => onSpeedChange(s)}
                className={`py-2 rounded-lg font-semibold transition-all ${
                  speed === s
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-700 hover:bg-gray-600'
                }`}
              >
                {s.charAt(0).toUpperCase() + s.slice(1)}
              </button>
            ))}
          </div>
        </div>

        {/* Restart */}
        <button
          onClick={onRestart}
          className="btn btn-secondary w-full"
        >
          🔄 Restart Game
        </button>
      </div>
    </div>
  );
}
