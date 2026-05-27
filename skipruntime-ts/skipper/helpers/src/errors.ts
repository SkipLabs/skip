import { CodeError } from "./routes.js";

export class AuthenticationError extends CodeError {
  constructor(error: string) {
    super(401, error);
  }
}

export class ConflictError extends CodeError {
  constructor(error: string) {
    super(409, error);
  }
}

export class InvalidParameterError extends CodeError {
  constructor(error: string) {
    super(400, error);
  }
}

export class ForbiddenError extends CodeError {
  constructor(error: string) {
    super(403, error);
  }
}

export class NotFoundError extends CodeError {
  constructor(error: string) {
    super(404, error);
  }
}
