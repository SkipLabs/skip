import { createContext } from "react";
import { Client } from "@skipruntime/client";

export const SkipContext = createContext<Client | null>(null);
