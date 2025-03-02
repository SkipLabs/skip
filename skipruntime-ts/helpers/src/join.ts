import type {
  EagerCollection,
  Json,
  JsonObject,
  Values,
  Mapper,
} from "@skipruntime/core";

export class JoinOneMapper<
  IdProperty extends string,
  JoinedProperty extends string,
  KLeft extends Json,
  VLeft extends JsonObject & { [K in IdProperty]: KRight },
  KRight extends Json,
  VRight extends Json,
> implements
    Mapper<
      KLeft,
      VLeft,
      KLeft,
      Omit<VLeft, IdProperty> & Record<JoinedProperty, VRight>
    >
{
  constructor(
    private right: EagerCollection<KRight, VRight>,
    private readonly id_property: IdProperty,
    private readonly joined_property: JoinedProperty,
  ) {}

  mapEntry(
    key: KLeft,
    values: Values<VLeft>,
  ): Iterable<
    [KLeft, Omit<VLeft, IdProperty> & Record<JoinedProperty, VRight>]
  > {
    return values.toArray().map((v: VLeft) => {
      const { [this.id_property]: key_right, ...value_left } = v;
      const value_right = {
        [this.joined_property]: this.right.getUnique(key_right),
      } as Record<JoinedProperty, VRight>;
      const value_out = { ...value_left, ...value_right };
      return [key, value_out];
    });
  }
}

class ProjectionMapper<
  ProjectionProperty extends string,
  KIn extends Json,
  V extends JsonObject & { [K in ProjectionProperty]: KOut },
  KOut extends Json,
> implements Mapper<KIn, V, KOut, Omit<V, ProjectionProperty>>
{
  constructor(private readonly proj_property: ProjectionProperty) {}

  mapEntry(
    _key: KIn,
    values: Values<V>,
  ): Iterable<[KOut, Omit<V, ProjectionProperty>]> {
    return values.toArray().map((v: V) => {
      const { [this.proj_property]: new_key, ...new_value } = v;
      return [new_key, new_value];
    });
  }
}

export class JoinManyMapper<
  IdProperty extends string,
  JoinedProperty extends string,
  KLeft extends Json,
  VLeft extends JsonObject,
  KRight extends Json,
  VRight extends JsonObject & { [K in IdProperty]: KLeft },
> implements
    Mapper<
      KLeft,
      VLeft,
      KLeft,
      VLeft & Record<JoinedProperty, Omit<VRight, IdProperty>[]>
    >
{
  readonly right: EagerCollection<KLeft, Omit<VRight, IdProperty>>;

  constructor(
    right: EagerCollection<KRight, VRight>,
    id_property: IdProperty,
    private readonly joined_property: JoinedProperty,
  ) {
    this.right = right.map(
      ProjectionMapper<IdProperty, KRight, VRight, KLeft>,
      id_property,
    );
  }

  mapEntry(
    key: KLeft,
    values: Values<VLeft>,
  ): Iterable<
    [KLeft, VLeft & Record<JoinedProperty, Omit<VRight, IdProperty>[]>]
  > {
    return values.toArray().map((value_left: VLeft) => {
      const value_right = {
        [this.joined_property]: this.right.getArray(key) as Omit<
          VRight,
          IdProperty
        >[],
      };
      const value_out = { ...value_left, ...value_right };
      return [key, value_out];
    });
  }
}
