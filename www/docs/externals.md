# Data sources and destinations

Skip is designed to carefully track the computation and data dependencies of your application, so that outputs can be efficiently updated if (and only if!) any inputs they depend on change.
However, when those inputs come from external systems or services it is crucial to ensure that your reactive service still produces up-to-date results.

Skip provides mechanisms to do so easily, whether those external systems are other reactive Skip services or non-reactive systems like databases or external APIs.

## Overview

### External Skip Services

### Non-Skip Services

### Streaming sources

TODO: set up an example with a streaming source!
