import React, { useState, useRef, useEffect } from 'react';
import { ChevronDown, Sparkles, Lock, Play, Settings } from 'lucide-react';
import './LootboxUI.css';

interface LootItem {
  id: number;
  name: string;
  amount: number;
  weight: number;
  percentage: number;
  rarity?: 'common' | 'rare' | 'epic' | 'legendary';
  icon: string;
  image?: string;
}

interface SoundOption {
  id: number;
  name: string;
  description: string;
  color: string;
}

interface LootboxUIProps {
  items?: LootItem[];
  onSpin?: () => Promise<boolean>;
  spinResult?: number | null;
  onSpinResultHandled?: () => void;
  onClose?: () => void;
  caseTitle?: string;
  caseTitleColor?: string;
}

const LootboxUI: React.FC<LootboxUIProps> = ({
  items: propsItems,
  onSpin,
  spinResult,
  onSpinResultHandled,
  onClose,
  caseTitle = 'MYSTERY LOOTBOX',
  caseTitleColor = '#FBBF24'
}) => {
  const [isSpinning, setIsSpinning] = useState(false);
  const [selectedItem, setSelectedItem] = useState<LootItem | null>(null);
  const [currentOffset, setCurrentOffset] = useState(0);
  const [centerItemIndex, setCenterItemIndex] = useState(0);
  const [showSoundPicker, setShowSoundPicker] = useState(false);
  const [selectedSound, setSelectedSound] = useState(3);
  const [playingSound, setPlayingSound] = useState<number | null>(null);
  const [isWinning, setIsWinning] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const audioContextRef = useRef<AudioContext | null>(null);
  const animationRef = useRef<number | null>(null);

  const items: LootItem[] = propsItems || [];

  const calculateRarity = (percentage: number): 'common' | 'rare' | 'epic' | 'legendary' => {
    if (percentage >= 30) return 'common';
    if (percentage >= 15) return 'rare';
    if (percentage >= 5) return 'epic';
    return 'legendary';
  };

  const itemsWithRarity = items.map(item => ({
    ...item,
    rarity: calculateRarity(item.percentage)
  }));

  const soundOptions: SoundOption[] = [
    { id: 1, name: 'Whisper Tick', description: 'Ultra-light, barely audible', color: 'from-blue-500 to-cyan-500' },
    { id: 2, name: 'Soft Touch', description: 'Gentle and smooth', color: 'from-purple-500 to-pink-500' },
    { id: 3, name: 'Mechanical Switch', description: 'Crisp keyboard click', color: 'from-gray-500 to-gray-700' },
    { id: 4, name: 'Wood Block', description: 'Natural percussion', color: 'from-amber-600 to-orange-600' },
    { id: 5, name: 'Digital Pulse', description: 'Clean electronic beep', color: 'from-green-500 to-emerald-500' },
    { id: 6, name: 'Casino Chip', description: 'Authentic casino sound', color: 'from-red-500 to-rose-600' },
    { id: 7, name: 'Coin Drop', description: 'Classic arcade coin', color: 'from-yellow-500 to-yellow-600' },
    { id: 8, name: 'Bubble Pop', description: 'Playful and light', color: 'from-teal-400 to-blue-500' },
    { id: 9, name: '8-Bit Blip', description: 'Vintage game sound', color: 'from-indigo-500 to-purple-600' },
    { id: 10, name: 'Glass Tap', description: 'Crystal clear tone', color: 'from-sky-400 to-blue-600' },
    { id: 11, name: 'Metal Click', description: 'Sharp metallic ping', color: 'from-slate-400 to-zinc-600' },
    { id: 12, name: 'Soft Thud', description: 'Muffled impact', color: 'from-stone-500 to-brown-600' },
    { id: 13, name: 'Electric Zap', description: 'Quick static burst', color: 'from-violet-500 to-fuchsia-500' },
    { id: 14, name: 'Water Drop', description: 'Liquid plop sound', color: 'from-blue-400 to-blue-600' },
    { id: 15, name: 'Typewriter', description: 'Classic key strike', color: 'from-neutral-500 to-gray-600' },
    { id: 16, name: 'Laser Shot', description: 'Sci-fi pew sound', color: 'from-pink-500 to-red-500' },
    { id: 17, name: 'Cork Pop', description: 'Bottle opening', color: 'from-orange-400 to-amber-500' },
    { id: 18, name: 'Switch Toggle', description: 'Light switch flip', color: 'from-lime-500 to-green-600' },
    { id: 19, name: 'Ping Pong', description: 'Table tennis hit', color: 'from-rose-400 to-pink-600' },
    { id: 20, name: 'Silent Click', description: 'Nearly inaudible', color: 'from-gray-600 to-gray-800' }
  ];

  const getDisplayItems = () => {
    const displayItems = [];
    for (let i = -4; i <= 4; i++) {
      let index = (centerItemIndex + i) % itemsWithRarity.length;
      if (index < 0) index += itemsWithRarity.length;
      displayItems.push({
        item: itemsWithRarity[index],
        position: i,
        actualIndex: index
      });
    }
    return displayItems;
  };

  useEffect(() => {
    audioContextRef.current = new (window.AudioContext || (window as any).webkitAudioContext)();
    return () => {
      if (audioContextRef.current) {
        audioContextRef.current.close();
      }
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  useEffect(() => {
    if (spinResult !== null && spinResult !== undefined && !isSpinning) {
      const targetIndex = itemsWithRarity.findIndex(item => item.id === spinResult);
      if (targetIndex !== -1) {
        spinToItem(targetIndex);
      }
      onSpinResultHandled?.();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [spinResult]);

  const playClickSound = (soundType?: number) => {
    if (!audioContextRef.current) return;

    const type = soundType ?? selectedSound;
    const ctx = audioContextRef.current;
    const oscillator = ctx.createOscillator();
    const gainNode = ctx.createGain();
    const filter = ctx.createBiquadFilter();

    oscillator.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(ctx.destination);

    const now = ctx.currentTime;

    switch(type) {
      case 1:
        oscillator.frequency.value = 2000;
        oscillator.type = 'sine';
        gainNode.gain.setValueAtTime(0.03, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.003);
        oscillator.start(now);
        oscillator.stop(now + 0.003);
        break;

      case 2:
        oscillator.frequency.value = 400;
        oscillator.type = 'sine';
        filter.type = 'lowpass';
        filter.frequency.value = 600;
        gainNode.gain.setValueAtTime(0.12, now);
        gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.025);
        oscillator.start(now);
        oscillator.stop(now + 0.025);
        break;

      case 3:
        oscillator.frequency.value = 800;
        oscillator.type = 'square';
        gainNode.gain.setValueAtTime(0.06, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.006);
        oscillator.start(now);
        oscillator.stop(now + 0.006);
        break;

      case 4:
        oscillator.frequency.value = 150;
        oscillator.type = 'triangle';
        filter.type = 'bandpass';
        filter.frequency.value = 200;
        filter.Q.value = 0.5;
        gainNode.gain.setValueAtTime(0.25, now);
        gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.008);
        oscillator.start(now);
        oscillator.stop(now + 0.008);
        break;

      case 5:
        oscillator.frequency.value = 880;
        oscillator.type = 'triangle';
        gainNode.gain.setValueAtTime(0.08, now);
        gainNode.gain.linearRampToValueAtTime(0.08, now + 0.01);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.015);
        oscillator.start(now);
        oscillator.stop(now + 0.015);
        break;

      case 6:
        oscillator.frequency.setValueAtTime(1200, now);
        oscillator.frequency.exponentialRampToValueAtTime(400, now + 0.02);
        oscillator.type = 'sine';
        gainNode.gain.setValueAtTime(0.15, now);
        gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.03);
        oscillator.start(now);
        oscillator.stop(now + 0.03);
        break;

      case 7:
        oscillator.frequency.setValueAtTime(1500, now);
        oscillator.frequency.exponentialRampToValueAtTime(600, now + 0.04);
        oscillator.type = 'square';
        gainNode.gain.setValueAtTime(0.04, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.04);
        oscillator.start(now);
        oscillator.stop(now + 0.04);
        break;

      case 8:
        oscillator.frequency.value = 1600;
        oscillator.type = 'sine';
        filter.type = 'highpass';
        filter.frequency.value = 1000;
        gainNode.gain.setValueAtTime(0.1, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.004);
        oscillator.start(now);
        oscillator.stop(now + 0.004);
        break;

      case 9:
        oscillator.frequency.value = 440;
        oscillator.type = 'square';
        gainNode.gain.setValueAtTime(0.05, now);
        gainNode.gain.setValueAtTime(0.05, now + 0.01);
        gainNode.gain.setValueAtTime(0, now + 0.011);
        oscillator.start(now);
        oscillator.stop(now + 0.012);
        break;

      case 10:
        oscillator.frequency.value = 2400;
        oscillator.type = 'sine';
        const oscillator2 = ctx.createOscillator();
        oscillator2.frequency.value = 3600;
        oscillator2.type = 'sine';
        oscillator2.connect(gainNode);
        gainNode.gain.setValueAtTime(0.07, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.02);
        oscillator.start(now);
        oscillator2.start(now);
        oscillator.stop(now + 0.02);
        oscillator2.stop(now + 0.02);
        break;

      case 11:
        oscillator.frequency.value = 3000;
        oscillator.type = 'triangle';
        gainNode.gain.setValueAtTime(0.08, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.002);
        oscillator.start(now);
        oscillator.stop(now + 0.002);
        break;

      case 12:
        oscillator.frequency.value = 80;
        oscillator.type = 'sine';
        gainNode.gain.setValueAtTime(0.3, now);
        gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.015);
        oscillator.start(now);
        oscillator.stop(now + 0.015);
        break;

      case 13:
        oscillator.frequency.setValueAtTime(2000, now);
        oscillator.frequency.linearRampToValueAtTime(100, now + 0.01);
        oscillator.type = 'sawtooth';
        gainNode.gain.setValueAtTime(0.06, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.01);
        oscillator.start(now);
        oscillator.stop(now + 0.01);
        break;

      case 14:
        oscillator.frequency.setValueAtTime(400, now);
        oscillator.frequency.exponentialRampToValueAtTime(1200, now + 0.01);
        oscillator.frequency.exponentialRampToValueAtTime(400, now + 0.02);
        oscillator.type = 'sine';
        gainNode.gain.setValueAtTime(0.15, now);
        gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.025);
        oscillator.start(now);
        oscillator.stop(now + 0.025);
        break;

      case 15:
        oscillator.frequency.value = 1000;
        oscillator.type = 'square';
        filter.type = 'bandpass';
        filter.frequency.value = 1000;
        filter.Q.value = 10;
        gainNode.gain.setValueAtTime(0.1, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.003);
        oscillator.start(now);
        oscillator.stop(now + 0.003);
        break;

      case 16:
        oscillator.frequency.setValueAtTime(3000, now);
        oscillator.frequency.exponentialRampToValueAtTime(200, now + 0.05);
        oscillator.type = 'sawtooth';
        gainNode.gain.setValueAtTime(0.05, now);
        gainNode.gain.linearRampToValueAtTime(0.05, now + 0.02);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.05);
        oscillator.start(now);
        oscillator.stop(now + 0.05);
        break;

      case 17:
        const noise = ctx.createBufferSource();
        const buffer = ctx.createBuffer(1, ctx.sampleRate * 0.01, ctx.sampleRate);
        const data = buffer.getChannelData(0);
        for (let i = 0; i < data.length; i++) {
          data[i] = Math.random() * 2 - 1;
        }
        noise.buffer = buffer;
        noise.connect(gainNode);
        gainNode.gain.setValueAtTime(0.2, now);
        gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.01);
        noise.start(now);
        break;

      case 18:
        oscillator.frequency.value = 600;
        oscillator.type = 'square';
        gainNode.gain.setValueAtTime(0, now);
        gainNode.gain.linearRampToValueAtTime(0.08, now + 0.002);
        gainNode.gain.linearRampToValueAtTime(0, now + 0.004);
        oscillator.start(now);
        oscillator.stop(now + 0.004);
        break;

      case 19:
        oscillator.frequency.value = 1800;
        oscillator.type = 'sine';
        gainNode.gain.setValueAtTime(0.1, now);
        gainNode.gain.exponentialRampToValueAtTime(0.05, now + 0.01);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.02);
        oscillator.start(now);
        oscillator.stop(now + 0.02);
        break;

      case 20:
        oscillator.frequency.value = 500;
        oscillator.type = 'sine';
        gainNode.gain.setValueAtTime(0.01, now);
        gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.002);
        oscillator.start(now);
        oscillator.stop(now + 0.002);
        break;
    }

    if (soundType) {
      setPlayingSound(soundType);
      setTimeout(() => setPlayingSound(null), 100);
    }
  };

  const spinToItem = (targetIndex: number) => {
    if (isSpinning) return;

    setIsSpinning(true);
    setSelectedItem(null);
    setIsWinning(false);

    const rotations = 8 + Math.floor(Math.random() * 5);
    const randomOffset = 0.1 + Math.random() * 0.4;
    const stepsToTarget = (targetIndex - centerItemIndex + itemsWithRarity.length) % itemsWithRarity.length;
    const totalSteps = rotations * itemsWithRarity.length + stepsToTarget + randomOffset;

    const startTime = Date.now();
    const duration = 8000;
    let lastSoundTime = 0;
    let lastItemIndex = centerItemIndex;
    const startIndex = centerItemIndex;

    const animate = () => {
      const elapsed = Date.now() - startTime;
      const progress = Math.min(elapsed / duration, 1);
      const easeOut = 1 - Math.pow(1 - progress, 4);
      const currentStep = totalSteps * easeOut;
      const itemsMovedComplete = Math.floor(currentStep);
      const itemProgress = currentStep - itemsMovedComplete;
      const newCenterIndex = (startIndex + itemsMovedComplete) % itemsWithRarity.length;
      const pixelOffset = itemProgress * 198;

      setCenterItemIndex(newCenterIndex);
      setCurrentOffset(pixelOffset);

      if (newCenterIndex !== lastItemIndex) {
        lastItemIndex = newCenterIndex;
        const currentTime = Date.now();
        const minInterval = 50 * (1 + progress * 3);
        if (currentTime - lastSoundTime > minInterval) {
          playClickSound();
          lastSoundTime = currentTime;
        }
      }

      if (progress < 1) {
        animationRef.current = requestAnimationFrame(animate);
      } else {
        const finalItemIndex = newCenterIndex;
        const finalOffset = pixelOffset;
        const landedItemIndex = targetIndex;
        const centerDuration = 800;
        const centerStartTime = Date.now();
        const startCenterIndex = finalItemIndex;
        const startOffset = finalOffset;
        let itemsToMove = (landedItemIndex - finalItemIndex + itemsWithRarity.length) % itemsWithRarity.length;
        const totalPixelDistance = itemsToMove * 198 - startOffset;

        const centerAnimate = () => {
          const centerElapsed = Date.now() - centerStartTime;
          const centerProgress = Math.min(centerElapsed / centerDuration, 1);
          const easeCenter = 1 - Math.pow(1 - centerProgress, 3);

          if (centerProgress < 1) {
            const pixelsMoved = totalPixelDistance * easeCenter;
            const currentPixelOffset = startOffset + pixelsMoved;
            const itemsMoved = Math.floor(currentPixelOffset / 198);
            const newCenterIdx = (startCenterIndex + itemsMoved + itemsWithRarity.length) % itemsWithRarity.length;
            const newOffset = currentPixelOffset - (itemsMoved * 198);

            setCenterItemIndex(newCenterIdx);
            setCurrentOffset(newOffset);
            animationRef.current = requestAnimationFrame(centerAnimate);
          } else {
            setCenterItemIndex(landedItemIndex);
            setCurrentOffset(0);
            setIsSpinning(false);
            setSelectedItem(itemsWithRarity[landedItemIndex]);
            setIsWinning(true);
            animationRef.current = null;
          }
        };

        animationRef.current = requestAnimationFrame(centerAnimate);
      }
    };

    animationRef.current = requestAnimationFrame(animate);
  };

  const spin = async () => {
    if (isSpinning) return;

    if (onSpin) {
      const canSpin = await onSpin();
      if (!canSpin) return;
    } else {
      const targetIndex = Math.floor(Math.random() * itemsWithRarity.length);
      spinToItem(targetIndex);
    }
  };

  const getRarityColor = (rarity: 'common' | 'rare' | 'epic' | 'legendary', isCenter: boolean = false) => {
    const baseColors = {
      common: 'relative bg-gradient-to-br from-gray-600/70 via-gray-700/50 to-gray-900/90',
      rare: 'relative bg-gradient-to-br from-blue-500/60 via-blue-700/50 to-blue-950/90',
      epic: 'relative bg-gradient-to-br from-purple-500/70 via-purple-700/50 to-purple-950/90',
      legendary: 'relative bg-gradient-to-br from-yellow-500/80 via-orange-600/60 to-yellow-900/90'
    };

    const highlightColors = {
      common: 'relative bg-gradient-to-br from-gray-500/80 via-gray-600/60 to-gray-800',
      rare: 'relative bg-gradient-to-br from-blue-400/70 via-blue-600/60 to-blue-900',
      epic: 'relative bg-gradient-to-br from-purple-400/80 via-purple-600/60 to-purple-900',
      legendary: 'relative bg-gradient-to-br from-yellow-400/90 via-orange-500/70 to-yellow-800 animate-pulse'
    };

    const colors = isCenter && !isSpinning ? highlightColors : baseColors;
    return colors[rarity] || colors.common;
  };

  const getRarityBorder = (rarity: 'common' | 'rare' | 'epic' | 'legendary') => {
    const borders = {
      common: 'border-4 border-gray-500',
      rare: 'border-4 border-blue-400',
      epic: 'border-4 border-purple-400',
      legendary: 'border-4 border-yellow-300'
    };
    return borders[rarity] || borders.common;
  };

  const getRarityLabel = (rarity: 'common' | 'rare' | 'epic' | 'legendary') => {
    const labels = {
      common: 'COMMON',
      rare: 'RARE',
      epic: 'EPIC',
      legendary: 'LEGENDARY'
    };
    return labels[rarity] || 'COMMON';
  };

  const getRarityTextColor = (rarity: 'common' | 'rare' | 'epic' | 'legendary') => {
    const colors = {
      common: 'text-gray-500',
      rare: 'text-blue-400',
      epic: 'text-purple-400',
      legendary: 'text-yellow-400'
    };
    return colors[rarity] || 'text-gray-500';
  };

  const getGradientColors = (colorClass: string): string => {
    const gradientMap: { [key: string]: string } = {
      'from-blue-500 to-cyan-500': '#3b82f6, #06b6d4',
      'from-purple-500 to-pink-500': '#a855f7, #ec4899',
      'from-gray-500 to-gray-700': '#6b7280, #374151',
      'from-amber-600 to-orange-600': '#d97706, #ea580c',
      'from-green-500 to-emerald-500': '#22c55e, #10b981',
      'from-red-500 to-rose-600': '#ef4444, #e11d48',
      'from-yellow-500 to-yellow-600': '#eab308, #ca8a04',
      'from-teal-400 to-blue-500': '#2dd4bf, #3b82f6',
      'from-indigo-500 to-purple-600': '#6366f1, #9333ea',
      'from-sky-400 to-blue-600': '#38bdf8, #2563eb',
      'from-slate-400 to-zinc-600': '#94a3b8, #52525b',
      'from-stone-500 to-brown-600': '#78716c, #92400e',
      'from-violet-500 to-fuchsia-500': '#8b5cf6, #d946ef',
      'from-blue-400 to-blue-600': '#60a5fa, #2563eb',
      'from-neutral-500 to-gray-600': '#737373, #4b5563',
      'from-lime-500 to-green-600': '#84cc16, #16a34a',
      'from-rose-400 to-pink-600': '#fb7185, #db2777',
      'from-orange-400 to-amber-500': '#fb923c, #f59e0b',
      'from-pink-500 to-red-500': '#ec4899, #ef4444',
      'from-gray-600 to-gray-800': '#4b5563, #1f2937'
    };
    return gradientMap[colorClass] || '#6b7280, #374151';
  };

  const displayItems = getDisplayItems();

  return (
    <div className="fixed inset-0 bg-black/60 flex flex-col items-center justify-center p-8">
      {showSoundPicker && (
        <div className="fixed inset-0 bg-gradient-to-b from-black/60 via-black/70 to-black/80 z-50 flex items-center justify-center p-8">
          <div className="bg-gray-900 rounded-2xl p-6 max-w-2xl w-full border border-gray-700 shadow-2xl">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-2xl font-black text-white">Sound Settings</h3>
              <button
                onClick={() => setShowSoundPicker(false)}
                className="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center transition-all text-gray-400 hover:text-white"
              >
                ✕
              </button>
            </div>

            <div className="grid grid-cols-2 gap-2 max-h-80 overflow-y-auto pr-2 custom-scrollbar">
              {soundOptions.map(sound => (
                <button
                  key={sound.id}
                  onClick={() => {
                    playClickSound(sound.id);
                    setSelectedSound(sound.id);
                  }}
                  className={`relative p-3 rounded-lg border-2 transition-all group overflow-hidden ${
                    selectedSound === sound.id ? 'border-green-500' : 'border-gray-700 hover:border-gray-600'
                  }`}
                  style={{
                    background: selectedSound === sound.id
                      ? 'linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.2))'
                      : 'rgba(31, 41, 55, 0.5)'
                  }}
                >
                  <div
                    className={`absolute inset-0 bg-gradient-to-br ${sound.color} transition-opacity`}
                    style={{ opacity: selectedSound === sound.id ? 0.15 : 0.08 }}
                  ></div>

                  <div className="relative flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2 flex-1">
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          playClickSound(sound.id);
                        }}
                        className={`w-8 h-8 rounded-md flex items-center justify-center transition-all flex-shrink-0 ${
                          playingSound === sound.id ? 'scale-95' : ''
                        }`}
                        style={{
                          background: `linear-gradient(135deg, ${getGradientColors(sound.color)})`
                        }}
                      >
                        <Play className={`w-3 h-3 text-white ${playingSound === sound.id ? 'animate-pulse' : ''}`} />
                      </button>

                      <div className="text-left flex-1">
                        <p className="text-white font-semibold text-sm">{sound.name}</p>
                        <p className="text-gray-400 text-xs">{sound.description}</p>
                      </div>

                      <div className="flex items-center gap-0.5 mr-2">
                        {[...Array(5)].map((_, i) => (
                          <div
                            key={i}
                            className="w-0.5 rounded-full transition-all"
                            style={{
                              background: `linear-gradient(to top, ${getGradientColors(sound.color)})`,
                              opacity: selectedSound === sound.id ? 1 : 0.3,
                              height: `${4 + Math.sin((i + 1) * 0.8) * 4}px`
                            }}
                          ></div>
                        ))}
                      </div>
                    </div>
                  </div>
                </button>
              ))}
            </div>

            <div className="mt-4 flex justify-end">
              <button
                onClick={() => setShowSoundPicker(false)}
                className="px-6 py-2 bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-500 hover:to-emerald-500 text-white font-semibold text-sm rounded-lg transition-all shadow-lg hover:shadow-green-500/30"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}

      <div className="w-full max-w-7xl">
        <div className="flex items-center justify-center gap-4 mb-12">
          <h1 className="text-5xl font-black tracking-wider" style={{ color: caseTitleColor }}>
            {caseTitle}
          </h1>
        </div>

        <div className="relative bg-gray-950 rounded-2xl p-6 overflow-hidden border-2 border-gray-700 shadow-2xl" style={{ outline: '2px solid rgba(156, 163, 175, 0.2)' }}>
          <div className="absolute left-1/2 -translate-x-1/2 z-20" style={{ top: '4px' }}>
            <ChevronDown className="text-yellow-400 w-10 h-10" />
          </div>

          <div ref={containerRef} className="relative h-44 overflow-hidden bg-gray-950/80 rounded-xl border-2 border-gray-600">
            <div className="absolute left-1/2 top-0 bottom-0 w-0.5 bg-yellow-400/20 -translate-x-1/2 z-10"></div>

            <div
              className="flex items-center gap-1.5 absolute top-1/2 left-1/2"
              style={{
                transform: `translate(calc(-50% - ${currentOffset}px), -50%)`,
                transition: 'none'
              }}
            >
              {displayItems.map((displayItem, idx) => {
                const isCenter = displayItem.position === 0;
                const isWinningItem = isCenter && isWinning && selectedItem?.id === displayItem.item.id;
                return (
                  <div
                    key={`${displayItem.actualIndex}-${idx}-${displayItem.position}`}
                    className={`flex-shrink-0 w-48 h-44 ${getRarityColor(displayItem.item.rarity, isCenter)} ${getRarityBorder(displayItem.item.rarity)} rounded-xl p-4 flex flex-col items-center justify-between transition-all duration-300 ${
                      isCenter && !isSpinning && !selectedItem ? 'scale-110' : 'scale-95'
                    }`}
                    style={{
                      boxShadow: isWinningItem
                        ? displayItem.item.rarity === 'legendary'
                          ? '0 0 40px rgba(250, 204, 21, 1), inset 0 0 50px rgba(250, 204, 21, 0.5)'
                          : displayItem.item.rarity === 'epic'
                          ? '0 0 35px rgba(192, 132, 252, 1), inset 0 0 45px rgba(192, 132, 252, 0.5)'
                          : displayItem.item.rarity === 'rare'
                          ? '0 0 30px rgba(96, 165, 250, 1), inset 0 0 40px rgba(96, 165, 250, 0.5)'
                          : '0 0 25px rgba(156, 163, 175, 0.8), inset 0 0 35px rgba(156, 163, 175, 0.4)'
                        : displayItem.item.rarity === 'legendary'
                        ? '0 0 25px rgba(250, 204, 21, 0.7), inset 0 0 30px rgba(250, 204, 21, 0.3)'
                        : displayItem.item.rarity === 'epic'
                        ? '0 0 20px rgba(192, 132, 252, 0.6), inset 0 0 25px rgba(192, 132, 252, 0.25)'
                        : displayItem.item.rarity === 'rare'
                        ? '0 0 15px rgba(96, 165, 250, 0.5), inset 0 0 20px rgba(96, 165, 250, 0.2)'
                        : 'inset 0 0 15px rgba(156, 163, 175, 0.1)',
                      animation: isWinningItem ? 'winning-pulse 1s ease-in-out infinite' : undefined
                    }}
                  >
                    <div
                      className="absolute inset-0 rounded-xl opacity-30 pointer-events-none"
                      style={{
                        background: displayItem.item.rarity === 'legendary'
                          ? 'radial-gradient(circle at center, rgba(250, 204, 21, 0.4) 0%, transparent 70%)'
                          : displayItem.item.rarity === 'epic'
                          ? 'radial-gradient(circle at center, rgba(192, 132, 252, 0.35) 0%, transparent 70%)'
                          : displayItem.item.rarity === 'rare'
                          ? 'radial-gradient(circle at center, rgba(96, 165, 250, 0.3) 0%, transparent 70%)'
                          : 'radial-gradient(circle at center, rgba(156, 163, 175, 0.15) 0%, transparent 70%)'
                      }}
                    ></div>

                    <span className={`text-xs font-bold ${getRarityTextColor(displayItem.item.rarity)} tracking-wider opacity-80 relative z-10`}>
                      {getRarityLabel(displayItem.item.rarity)}
                    </span>
                    <div className="mb-2 relative z-10 w-20 h-20 flex items-center justify-center overflow-hidden">
                      {displayItem.item.image ? (
                        <img
                          src={displayItem.item.image}
                          alt={displayItem.item.name}
                          className="w-full h-full object-scale-down p-1"
                          style={{
                            objectFit: 'scale-down',
                            maxWidth: '100%',
                            maxHeight: '100%'
                          }}
                        />
                      ) : (
                        <div className="text-6xl">
                          {displayItem.item.icon}
                        </div>
                      )}
                    </div>
                    <div className="text-center relative z-10">
                      <p className="text-white text-sm font-semibold truncate w-44">
                        {displayItem.item.name}
                      </p>
                      <p className="text-gray-500 text-xs font-medium">x{displayItem.item.amount}</p>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          <div className="absolute left-0 top-0 h-full w-32 bg-gradient-to-r from-black/80 via-black/40 to-transparent pointer-events-none z-10"></div>
          <div className="absolute right-0 top-0 h-full w-32 bg-gradient-to-l from-black/80 via-black/40 to-transparent pointer-events-none z-10"></div>
        </div>

        <div className="flex justify-between items-center mt-8">
          <div className="flex items-center gap-3 text-gray-500 text-sm">
            <span className="px-3 py-1 bg-gray-800 rounded border border-gray-700">ESC</span>
            <span>Close</span>
          </div>

          <button
            onClick={spin}
            disabled={isSpinning}
            className={`px-6 py-2 rounded-lg font-semibold text-sm transition-all duration-300 flex items-center gap-2 ${
              isSpinning
                ? 'bg-gray-800 text-gray-600 cursor-not-allowed border border-gray-700'
                : 'bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-500 hover:to-emerald-500 text-white shadow-lg hover:shadow-green-500/30 transform hover:scale-105 border border-green-500'
            }`}
          >
            {isSpinning ? (
              <>
                <Lock className="w-4 h-4" />
                <span>SPINNING...</span>
              </>
            ) : (
              <>
                <Sparkles className="w-4 h-4" />
                <span>OPEN CASE</span>
              </>
            )}
          </button>

          <button
            onClick={() => setShowSoundPicker(true)}
            className="flex items-center gap-2 px-3 py-1.5 bg-gray-800 hover:bg-gray-700 text-gray-400 hover:text-white rounded-lg transition-all text-sm border border-gray-700"
          >
            <Settings className="w-4 h-4" />
            <span>Sound</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default LootboxUI;
