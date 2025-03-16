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
  AsProperty extends string,
  KLeft extends Json,
  VLeft extends JsonObject & { [P in IdProperty]: Json },
  VRight extends Json,
> implements
    Mapper<
      KLeft,
      VLeft,
      KLeft,
      Omit<VLeft, IdProperty> & Record<AsProperty, VRight>
    >
{
  constructor(
    private readonly right: EagerCollection<VLeft[IdProperty], VRight>,
    private readonly id: IdProperty,
    private readonly as: AsProperty,
  ) {}

  mapEntry(
    key: KLeft,
    values: Values<VLeft>,
  ): Iterable<[KLeft, Omit<VLeft, IdProperty> & Record<AsProperty, VRight>]> {
    return values.toArray().map((v: VLeft) => {
      const { [this.id]: key_right, ...value_left } = v;
      const value_right = {
        [this.as]: this.right.getUnique(key_right),
      } as Record<AsProperty, VRight>;
      const value_out = { ...value_left, ...value_right };
      return [key, value_out];
    });
  }
}

export function join_one<
  IdProperty extends keyof VLeft,
  AsProperty extends string,
  KLeft extends Json,
  VLeft extends JsonObject & { [P in IdProperty]: Json },
  VRight extends Json,
>(options: {
  left: EagerCollection<KLeft, VLeft>;
  right: EagerCollection<VLeft[IdProperty], VRight>;
  id: IdProperty;
  as: AsProperty;
}): EagerCollection<
  KLeft,
  Omit<VLeft, IdProperty> & Record<AsProperty, VRight>
> {
  return options.left.map(
    JoinOneMapper<IdProperty, AsProperty, KLeft, VLeft, VRight>,
    options.right,
    options.id,
    options.as,
  );
}

class ProjectionMapper<
  ProjectionProperty extends keyof V,
  K extends Json,
  V extends JsonObject & { [P in ProjectionProperty]: Json },
> implements Mapper<K, V, V[ProjectionProperty], V>
{
  constructor(private readonly proj_property: ProjectionProperty) {}

  mapEntry(_key: K, values: Values<V>): Iterable<[V[ProjectionProperty], V]> {
    return values.toArray().map((v: V) => {
      return [v[this.proj_property], v];
    });
  }
}

class JoinManyMapper<
  IdProperty extends keyof VRight,
  AsProperty extends string,
  K extends Json,
  VLeft extends JsonObject,
  VRight extends JsonObject & { [P in IdProperty]: Json },
> implements
    Mapper<
      VRight[IdProperty],
      VLeft,
      VRight[IdProperty],
      VLeft & Record<AsProperty, VRight[]>
    >
{
  private readonly right: EagerCollection<VRight[IdProperty], VRight>;

  constructor(
    right: EagerCollection<K, VRight>,
    on: IdProperty,
    private readonly as: AsProperty,
  ) {
    this.right = right.map(ProjectionMapper<IdProperty, K, VRight>, on);
  }

  mapEntry(
    key: VRight[IdProperty],
    values: Values<VLeft>,
  ): Iterable<[VRight[IdProperty], VLeft & Record<AsProperty, VRight[]>]> {
    return values.toArray().map((value_left: VLeft) => {
      const value_right = { [this.as]: this.right.getArray(key) } as Record<
        AsProperty,
        (VRight & DepSafe)[]
      >;
      const value_out = { ...value_left, ...value_right };
      return [key, value_out];
    });
  }
}

class SelectionMapper<
  P extends keyof V,
  K extends Json,
  V extends JsonObject & { [T in P]: Json },
> implements Mapper<K, V, K, V[P]>
{
  constructor(private readonly prop: P) {}

  mapEntry(key: K, values: Values<V>): Iterable<[K, V[P]]> {
    return values.toArray().map((v) => {
      return [key, v[this.prop]];
    });
  }
}

class JoinManyThroughMapper<
  IdLeftProperty extends keyof VThrough,
  IdRightProperty extends keyof VThrough,
  AsProperty extends string,
  VLeft extends JsonObject,
  VRight extends Json,
  KThrough extends Json,
  VThrough extends JsonObject & {
    [P in IdLeftProperty | IdRightProperty]: Json;
  },
> implements
    Mapper<
      VThrough[IdLeftProperty],
      VLeft,
      VThrough[IdLeftProperty],
      VLeft & Record<AsProperty, VRight[]>
    >
{
  private readonly through: EagerCollection<
    VThrough[IdLeftProperty],
    VThrough[IdRightProperty]
  >;

  constructor(
    private readonly right: EagerCollection<VThrough[IdRightProperty], VRight>,
    through: EagerCollection<KThrough, VThrough>,
    id_left: IdLeftProperty,
    id_right: IdRightProperty,
    private readonly as: AsProperty,
  ) {
    this.through = through
      .map(ProjectionMapper<IdLeftProperty, KThrough, VThrough>, id_left)
      .map(
        SelectionMapper<IdRightProperty, VThrough[IdLeftProperty], VThrough>,
        id_right,
      );
  }

  mapEntry(
    key: VThrough[IdLeftProperty],
    values: Values<VLeft>,
  ): Iterable<
    [VThrough[IdLeftProperty], VLeft & Record<AsProperty, VRight[]>]
  > {
    return values.toArray().map((value_left: VLeft) => {
      const value_right = {
        [this.as]: this.through
          .getArray(key)
          .map((id_right) => this.right.getUnique(id_right)),
      } as Record<AsProperty, (VRight & DepSafe)[]>;
      const value_out = { ...value_left, ...value_right };
      return [key, value_out];
    });
  }
}

export function join_many_through<
  IdLeftProperty extends keyof VThrough,
  IdRightProperty extends keyof VThrough,
  AsProperty extends string,
  VLeft extends JsonObject,
  VRight extends Json,
  KThrough extends Json,
  VThrough extends JsonObject & {
    [P in IdLeftProperty | IdRightProperty]: Json;
  },
>(options: {
  left: EagerCollection<VThrough[IdLeftProperty], VLeft>;
  right: EagerCollection<VThrough[IdRightProperty], VRight>;
  as: AsProperty;
  id_left: IdLeftProperty;
  id_right: IdRightProperty;
  through: EagerCollection<KThrough, VThrough>;
}): EagerCollection<
  VThrough[IdLeftProperty],
  VLeft & Record<AsProperty, VRight[]>
> {
  return options.left.map(
    JoinManyThroughMapper<
      IdLeftProperty,
      IdRightProperty,
      AsProperty,
      VLeft,
      VRight,
      KThrough,
      VThrough
    >,
    options.right,
    options.through,
    options.id_left,
    options.id_right,
    options.as,
  );
}

export function join_many<
  IdProperty extends keyof VRight,
  AsProperty extends string,
  KRight extends Json,
  VLeft extends JsonObject,
  VRight extends JsonObject & { [K in IdProperty]: Json },
>(options: {
  left: EagerCollection<VRight[IdProperty], VLeft>;
  right: EagerCollection<KRight, VRight>;
  id: IdProperty;
  as: AsProperty;
}): EagerCollection<VRight[IdProperty], VLeft & Record<AsProperty, VRight[]>> {
  return options.left.map(
    JoinManyMapper<IdProperty, AsProperty, KRight, VLeft, VRight>,
    options.right,
    options.id,
    options.as,
  );
}
