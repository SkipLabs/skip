import type {
  EagerCollection,
  Json,
  JsonObject,
  Values,
  Mapper,
  DepSafe,
} from "@skipruntime/core";

class JoinOneMapper<
  IdProperty extends keyof VLeft,
  JoinedProperty extends string,
  K extends Json,
  VLeft extends JsonObject & { [P in IdProperty]: Json },
  VRight extends Json,
> implements
    Mapper<
      K,
      VLeft,
      K,
      Omit<VLeft, IdProperty> & Record<JoinedProperty, VRight>
    >
{
  constructor(
    private readonly right: EagerCollection<VLeft[IdProperty], VRight>,
    private readonly on: IdProperty,
    private readonly name: JoinedProperty,
  ) {}

  mapEntry(
    key: K,
    values: Values<VLeft>,
  ): Iterable<[K, Omit<VLeft, IdProperty> & Record<JoinedProperty, VRight>]> {
    return values.toArray().map((v: VLeft) => {
      const { [this.on]: key_right, ...value_left } = v;
      const value_right = {
        [this.name]: this.right.getUnique(key_right),
      } as Record<JoinedProperty, VRight>;
      const value_out = { ...value_left, ...value_right } as const;
      return [key, value_out];
    });
  }
}

export function join_one<
  IdProperty extends keyof V1,
  JoinedProperty extends string,
  K extends Json,
  V1 extends JsonObject & { [P in IdProperty]: Json },
  V2 extends Json,
>(
  left: EagerCollection<K, V1>,
  right: EagerCollection<V1[IdProperty], V2>,
  options: {
    on: IdProperty;
    name: JoinedProperty;
  },
): EagerCollection<K, Omit<V1, IdProperty> & Record<JoinedProperty, V2>> {
  return left.map(
    JoinOneMapper<IdProperty, JoinedProperty, K, V1, V2>,
    right,
    options.on,
    options.name,
  );
}

class ProjectionMapper<
  ProjectionProperty extends keyof V,
  K extends Json,
  V extends JsonObject & { [P in ProjectionProperty]: Json },
> implements Mapper<K, V, V[ProjectionProperty], Omit<V, ProjectionProperty>>
{
  constructor(private readonly proj_property: ProjectionProperty) {}

  mapEntry(
    _key: K,
    values: Values<V>,
  ): Iterable<[V[ProjectionProperty], Omit<V, ProjectionProperty>]> {
    return values.toArray().map((v: V) => {
      const { [this.proj_property]: new_key, ...new_value } = v;
      return [new_key, new_value];
    });
  }
}

class JoinManyMapper<
  IdProperty extends keyof VRight,
  JoinedProperty extends string,
  K extends Json,
  VLeft extends JsonObject,
  VRight extends JsonObject & { [P in IdProperty]: Json },
> implements
    Mapper<
      VRight[IdProperty],
      VLeft,
      VRight[IdProperty],
      VLeft & Record<JoinedProperty, Omit<VRight, IdProperty>[]>
    >
{
  private readonly right: EagerCollection<
    VRight[IdProperty],
    Omit<VRight, IdProperty>
  >;

  constructor(
    right: EagerCollection<K, VRight>,
    on: IdProperty,
    private readonly name: JoinedProperty,
  ) {
    this.right = right.map(ProjectionMapper<IdProperty, K, VRight>, on);
  }

  mapEntry(
    key: VRight[IdProperty],
    values: Values<VLeft>,
  ): Iterable<
    [
      VRight[IdProperty],
      VLeft & Record<JoinedProperty, Omit<VRight, IdProperty>[]>,
    ]
  > {
    return values.toArray().map((value_left: VLeft) => {
      const value_right = { [this.name]: this.right.getArray(key) } as Record<
        JoinedProperty,
        (Omit<VRight, IdProperty> & DepSafe)[]
      >;
      const value_out = { ...value_left, ...value_right };
      return [key, value_out];
    });
  }
}

export function join_many<
  IdProperty extends keyof V2,
  JoinedProperty extends string,
  K extends Json,
  V1 extends JsonObject,
  V2 extends JsonObject & { [P in IdProperty]: Json },
>(
  left: EagerCollection<V2[IdProperty], V1>,
  right: EagerCollection<K, V2>,
  options: {
    on: IdProperty;
    name: JoinedProperty;
  },
): EagerCollection<
  V2[IdProperty],
  V1 & Record<JoinedProperty, Omit<V2, IdProperty>[]>
> {
  return left.map(
    JoinManyMapper<IdProperty, JoinedProperty, K, V1, V2>,
    right,
    options.on,
    options.name,
  );
}
