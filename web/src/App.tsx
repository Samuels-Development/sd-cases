import React, { useState, useEffect, useCallback } from 'react';
import './App.css';
import LootboxUI from './components/LootboxUI';

interface NUIMessage {
  action: string;
  items?: any[];
  itemId?: number;
  caseTitle?: string;
  caseTitleColor?: string;
  spinDuration?: number;
}

declare global {
  interface Window {
    GetParentResourceName?: () => string;
  }
}

const App: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [items, setItems] = useState<any[]>([]);
  const [spinResult, setSpinResult] = useState<number | null>(null);
  const [caseTitle, setCaseTitle] = useState<string>('MYSTERY LOOTBOX');
  const [caseTitleColor, setCaseTitleColor] = useState<string>('#FBBF24');
  const [spinDuration, setSpinDuration] = useState<number>(8000);

  const GetParentResourceName = useCallback(() => {
    if (window.GetParentResourceName) {
      return window.GetParentResourceName();
    }
    return 'sd-cases';
  }, []);

  const handleClose = useCallback(() => {
    fetch(`https://${GetParentResourceName()}/close`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({})
    }).catch((error) => {
      console.error('Failed to close:', error);
    });
  }, [GetParentResourceName]);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data: NUIMessage = event.data;
      
      switch (data.action) {
        case 'open':
          setVisible(true);
          if (data.items) {
            setItems(data.items);
          }
          if (data.caseTitle) {
            setCaseTitle(data.caseTitle);
          }
          if (data.caseTitleColor) {
            setCaseTitleColor(data.caseTitleColor);
          }
          if (data.spinDuration) {
            setSpinDuration(data.spinDuration);
          }
          break;
          
        case 'close':
          setVisible(false);
          setSpinResult(null);
          break;
          
        case 'spinResult':
          if (data.itemId !== undefined) {
            setSpinResult(data.itemId);
          }
          break;
      }
    };

    window.addEventListener('message', handleMessage);
    
    // Handle ESC key
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && visible) {
        handleClose();
      }
    };
    
    window.addEventListener('keydown', handleKeyPress);
    
    // Cleanup
    return () => {
      window.removeEventListener('message', handleMessage);
      window.removeEventListener('keydown', handleKeyPress);
    };
  }, [visible, handleClose]);

const handleSpin = async (): Promise<boolean> => {
    try {
      const response = await fetch(`https://${GetParentResourceName()}/spin`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      });
      
      const result = await response.json();
      return result.success;
    } catch (error) {
      console.error('[DEBUG App.tsx] Failed to request spin:', error);
      return false;
    }
  };

  if (!visible) return null;

  return (
    <div className="App fade-in">
      <LootboxUI
        items={items}
        onSpin={handleSpin}
        spinResult={spinResult}
        onSpinResultHandled={() => setSpinResult(null)}
        onClose={handleClose}
        caseTitle={caseTitle}
        caseTitleColor={caseTitleColor}
        spinDuration={spinDuration}
      />
    </div>
  );
};

export default App;