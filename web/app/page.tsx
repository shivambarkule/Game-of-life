'use client';

import React, { useState } from 'react';
import GameCanvas from '@/components/GameCanvas';
import PatternSelector from '@/components/PatternSelector';
import GameControls from '@/components/GameControls';
import ScoreDisplay from '@/components/ScoreDisplay';
import Leaderboard from '@/components/Leaderboard';
import GameOverModal from '@/components/GameOverModal';
import { useGameState } from '@/hooks/useGameState';
import { PatternName } from '@/types/game';

export default function Home() {
  const [selectedPattern, setSelectedPattern] = useState<PatternName | null>(null);
  const { gameState, loading, error, placePattern, togglePause, restart, setSpeed } =
    useGameState();

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="text-center">
          <div className="text-4xl mb-4">🎮</div>
          <p className="text-xl text-gray-400">Loading Game of Life...</p>
        </div>
      </div>
    );
  }

  if (error || !gameState) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="text-center">
          <p className="text-xl text-red-400 mb-4">Error: {error || 'Failed to load game'}</p>
          <button
            onClick={() => window.location.reload()}
            className="btn btn-primary"
          >
            Reload
          </button>
        </div>
      </div>
    );
  }

  return (
    <main className="min-h-screen bg-gray-900 p-4 md:p-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-5xl font-bold mb-2">🎮 Game of Life</h1>
          <p className="text-gray-400">Defend against incoming spaceships and gliders!</p>
        </div>

        {/* Main Game Area */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 mb-8">
          {/* Game Canvas - Takes up 3 columns on large screens */}
          <div className="lg:col-span-3">
            <div className="card">
              <GameCanvas
                gameState={gameState}
                selectedPattern={selectedPattern}
                onCellClick={(row, col) => {
                  if (selectedPattern) {
                    placePattern(selectedPattern, row, col);
                  }
                }}
              />
            </div>
          </div>

          {/* Right Sidebar */}
          <div className="space-y-6">
            <ScoreDisplay gameState={gameState} />
            <GameControls
              paused={gameState.paused}
              speed={gameState.speed}
              gameOver={gameState.gameOver}
              onPlayPause={togglePause}
              onRestart={restart}
              onSpeedChange={setSpeed}
            />
          </div>
        </div>

        {/* Bottom Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <PatternSelector
            selectedPattern={selectedPattern}
            onPatternSelect={setSelectedPattern}
          />
          <Leaderboard />
        </div>

        {/* Instructions */}
        <div className="mt-8 card">
          <h3 className="text-lg font-bold mb-4">📖 How to Play</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-300">
            <div>
              <p className="font-semibold text-blue-400 mb-2">🎯 Objective</p>
              <p>Defend the right side of the grid by placing patterns to intercept incoming enemies from the left.</p>
            </div>
            <div>
              <p className="font-semibold text-green-400 mb-2">🎮 Controls</p>
              <p>Select a pattern, then click on the right side (blue zone) to place it. Collisions destroy both patterns and earn points.</p>
            </div>
            <div>
              <p className="font-semibold text-yellow-400 mb-2">📊 Scoring</p>
              <p>+10 points for each enemy destroyed. -5 points for each enemy that escapes. Game over at 5 escaped enemies.</p>
            </div>
            <div>
              <p className="font-semibold text-purple-400 mb-2">⚡ Patterns</p>
              <p>Glider moves diagonally. Blinker, Toad, and Beacon oscillate. Use them strategically to block incoming threats.</p>
            </div>
          </div>
        </div>
      </div>

      {/* Game Over Modal */}
      <GameOverModal
        gameState={gameState}
        onRestart={restart}
        onClose={() => {}}
      />
    </main>
  );
}
