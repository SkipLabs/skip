import { ref, readonly } from 'vue';

// Session type can be expanded as needed
type Session = any;

const session = ref<Session | null>(null);

// On load, check for existing token and fetch session
const token = localStorage.getItem('jwt');
if (token) {
  fetchSession(token);
}

async function fetchSession(token: string) {
  try {
    const response = await fetch('/api/session', {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    if (response.ok) {
      const data = await response.json();
      session.value = data;
    } else {
      localStorage.removeItem('jwt');
      session.value = null;
    }
  } catch (error) {
    console.error('Session check failed:', error);
    localStorage.removeItem('jwt');
    session.value = null;
  }
}

async function login(username: string, password: string) {
  try {
    const response = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    });
    if (!response.ok) {
      throw new Error('Login failed: ' + response.status);
    }
    const { token: jwt, user } = await response.json();
    localStorage.setItem('jwt', jwt);
    session.value = user;
  } catch (error) {
    console.error('Login error:', error);
    throw error;
  }
}

function logout() {
  localStorage.removeItem('jwt');
  session.value = null;
}

export function useAuth() {
  return {
    session: readonly(session),
    login,
    logout,
  };
} 