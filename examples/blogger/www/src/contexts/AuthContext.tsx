import {
  createContext,
  useContext,
  useState,
  useEffect,
  ReactNode,
} from "react";
import { Session } from "../types";

interface AuthContextType {
  session: Session | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);

  useEffect(() => {
    // Check for existing token on load
    const token = localStorage.getItem("jwt");
    if (token) {
      fetchSession(token);
    }
  }, []);

  const fetchSession = async (token: string) => {
    try {
      const response = await fetch("/api/session", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      if (response.ok) {
        const data = await response.json();
        setSession(data);
      } else {
        localStorage.removeItem("jwt");
        setSession(null);
      }
    } catch (error) {
      console.error("Session check failed:", error);
      localStorage.removeItem("jwt");
      setSession(null);
    }
  };

  const login = async (username: string, password: string) => {
    try {
      const response = await fetch("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password }),
      });

      if (!response.ok) {
        throw new Error("Login failed: " + response.statusText);
      }

      const { token, user } = await response.json();
      localStorage.setItem("jwt", token);
      setSession(user);
    } catch (error) {
      console.error("Login error:", error);
      throw error;
    }
  };

  const logout = () => {
    localStorage.removeItem("jwt");
    setSession(null);
  };

  return (
    <AuthContext.Provider value={{ session, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
