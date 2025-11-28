'use client';

import React, { useCallback } from 'react';
import { GameState, PatternName } from '@/types/game';

interface GameCanvasProps {
  gameState: GameState;
  selectedPattern: PatternName | null;
  onCellClick: (row: number, col: number) => void;
}

export default function GameCanvas({
  gameState,
  selectedPattern,
  onCellClick,
}: GameCanvasProps) {
  const { grid } = gameState;
  const GRID_SIZE = 200;
  const CELL_SIZE = Math.max(2, Math.min(4, 800 / GRID_SIZE));

  const handleCellClick = useCallback(
    (row: number, col: number) => {
      if (selectedPattern) {
        onCellClick(row, col);
      }
    },
    [selectedPattern, onCellClick]
  );

  return (
    <div className="flex flex-col items-center gap-4">
      <div
        className="game-grid overflow-auto border-2 border-gray-600 rounded-lg"
        style={{
          gridTemplateColumns: `repeat(${GRID_SIZE}, ${CELL_SIZE}px)`,
          width: `${Math.min(800, GRID_SIZE * CELL_SIZE)}px`,
          height: `${Math.min(800, GRID_SIZE * CELL_SIZE)}px`,
        }}
      >
        {grid.map((row, rowIdx) =>
          row.map((cell, colIdx) => {
            const isEnemyZone = colIdx < 100;
            const isPlayerZone = colIdx >= 100;

            return (
              <div
                key={`${rowIdx}-${colIdx}`}
                className={`game-cell cursor-pointer ${
                  cell ? 'alive' : 'dead'
                } ${isEnemyZone ? 'enemy-zone' : ''} ${
                  isPlayerZone ? 'player-zone' : ''
                }`}
                style={{
                  width: `${CELL_SIZE}px`,
                  height: `${CELL_SIZE}px`,
                }}
                onClick={() => handleCellClick(rowIdx, colIdx)}
                title={`Row: ${rowIdx}, Col: ${colIdx}`}
              />
            );
          })
        )}
      </div>

      <div className="text-sm text-gray-400 text-center">
        <p>Left (Red): Enemy Zone | Right (Blue): Player Zone</p>
        <p>Click cells to place patterns (when one is selected)</p>
      </div>
    </div>
  );
}
