'use client';

import React from 'react';
import { PatternName } from '@/types/game';

interface PatternSelectorProps {
  selectedPattern: PatternName | null;
  onPatternSelect: (pattern: PatternName) => void;
}

const PATTERNS: { name: PatternName; description: string }[] = [
  { name: 'glider', description: 'Moves diagonally' },
  { name: 'blinker', description: 'Oscillates (period 2)' },
  { name: 'toad', description: 'Oscillates (period 2)' },
  { name: 'beacon', description: 'Oscillates (period 2)' },
];

export default function PatternSelector({
  selectedPattern,
  onPatternSelect,
}: PatternSelectorProps) {
  return (
    <div className="card">
      <h3 className="text-lg font-bold mb-4">Select Defensive Pattern</h3>
      <div className="grid grid-cols-2 gap-2">
        {PATTERNS.map((pattern) => (
          <button
            key={pattern.name}
            onClick={() => onPatternSelect(pattern.name)}
            className={`p-3 rounded-lg border-2 transition-all ${
              selectedPattern === pattern.name
                ? 'border-blue-500 bg-blue-900 bg-opacity-50'
                : 'border-gray-600 hover:border-gray-500'
            }`}
          >
            <div className="font-semibold capitalize">{pattern.name}</div>
            <div className="text-xs text-gray-400">{pattern.description}</div>
          </button>
        ))}
      </div>
      {selectedPattern && (
        <div className="mt-4 p-2 bg-green-900 bg-opacity-30 rounded text-green-300 text-sm">
          ✓ {selectedPattern} selected. Click on the player zone (right side) to place.
        </div>
      )}
    </div>
  );
}
