/* ***************************************************************************/
/* The type used to represent callable external functions. */
/* ***************************************************************************/
export class SKDBCallable<T1, T2> {
  private id: number;

  constructor(id: number) {
    this.id = id;
  }

  getId(): number {
    return this.id;
  }
}

export class ExternalFuns {
  private externalFuns: Array<(any) => any>;

  constructor() {
    this.externalFuns = [];
  }

  register<T1, T2>(f: (obj: T1) => T2): SKDBCallable<T1, T2> {
    if (typeof f != "function") {
      throw new Error("Only function can be registered");
    }
    let funId = this.externalFuns.length;
    this.externalFuns.push(f);
    return new SKDBCallable(funId);
  }

  call(funId: number, jso: object) {
    return this.externalFuns[funId]!(jso);
  }
}

/* ***************************************************************************/
/* Class for query results, extending Array<Object> with some common selectors
   and utility functions for ease of use. */
/* ***************************************************************************/
export class SkdbTable extends Array<Object> {
  scalarValue() : any {
    const row = this.onlyRow();
    const cols = Object.keys(row);
    if (cols.length != 1) {
      throw new Error(`Can't extract scalar: query yielded ${cols.length} columns`);
    }
    return row[cols[0]];
  }

  onlyRow (): Object {
    if (this.length != 1) {
      throw new Error(`Can't extract only row: got ${this.length} rows`);
    }
    return this[0];
  }

  onlyColumn(): Array<any> {
    let result = [] as Array<any>;
    for(const row of this) {
      const cols = Object.keys(row);
      if (cols.length != 1){
        throw new Error(`Can't extract only column: got ${cols.length} columns`);
      }
      result.push(row[cols[0]]);
    };
    return result;
  }

  column(col: string): Array<any> {
    return this.map((row) => {
      if(!row[col]) {
        throw new Error("Missing column: " + col);
      }
      return row[col];
    });
  }
}
