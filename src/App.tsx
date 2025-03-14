import React, { useEffect, useState } from 'react';
import { UPIPayment } from './components/UPIPayment';
import { Auth } from './components/Auth';
import { supabase } from './lib/supabase';


function App() {
  const [session, setSession] = useState<boolean>(false);
  

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(!!session);
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(!!session);
    });

    return () => subscription.unsubscribe();
  }, []);

  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center p-4">
      
      {session ? (
        <UPIPayment 
          upiId=""
          merchantName="TEST"
        />
      ) : (
        <Auth onAuthSuccess={() => setSession(true)} />
      )}
    </div>
  );
}

export default App;