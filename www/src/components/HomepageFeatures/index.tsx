import clsx from "clsx";
import Heading from "@theme/Heading";
import styles from "./styles.module.css";

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<"svg">>;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: "Why Skip",
    Svg: require("@site/static/img/hero.svg").default,
    description: (
      <>
        Paragraph explainer lorem ipsum. Paragraph explainer lorem ipsum.
        Paragraph explainer lorem ipsum. Paragraph explainer lorem ipsum.
        Paragraph explainer lorem ipsum. Paragraph explainer lorem ipsum.
        Paragraph explainer lorem ipsum. Paragraph explainer lorem ipsum.
        Paragraph explainer lorem ipsum.
      </>
    ),
  },
];

function Feature({ title, Svg, description }: FeatureItem) {
  return (
    <div className={clsx("col col")}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
