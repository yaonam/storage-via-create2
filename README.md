# Test Storage Patterns

This repo compares the deployment and call forwarding costs of three types of proxies: calldata, immutable storage, and bytecode. The proxy address must be computable and proxies must not read from storage.

## Gas Report

| src/Counter.sol:CalldataProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 56905                                  | 316             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3489            | 3489 | 3489   | 3489 | 1       |

| src/Counter.sol:ImmutableProxy contract |                 |      |        |      |         |
| --------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                         | Deployment Size |      |        |      |         |
| 79950                                   | 660             |      |        |      |         |
| Function Name                           | min             | avg  | median | max  | # calls |
| forward                                 | 3254            | 3254 | 3254   | 3254 | 1       |

| src/Counter.sol:BytecodeProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 80591                                  | 663             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3254            | 3254 | 3254   | 3254 | 1       |

| src/Counter.sol:Caller contract |                 |        |        |        |         |
| ------------------------------- | --------------- | ------ | ------ | ------ | ------- |
| Deployment Cost                 | Deployment Size |        |        |        |         |
| 565600                          | 2857            |        |        |        |         |
| Function Name                   | min             | avg    | median | max    | # calls |
| callBytecodeProxy               | 3919            | 3919   | 3919   | 3919   | 1       |
| callCalldataProxy               | 4440            | 4440   | 4440   | 4440   | 1       |
| callImmutableProxy              | 3897            | 3897   | 3897   | 3897   | 1       |
| deployBytecodeProxy             | 182024          | 182024 | 182024 | 182024 | 1       |
| deployCalldataProxy             | 133797          | 133797 | 133797 | 133797 | 1       |
| deployImmutableProxy            | 137122          | 137122 | 137122 | 137122 | 1       |
| getImplAndCred                  | 423             | 423    | 423    | 423    | 1       |

| src/Counter.sol:Implementation contract |                 |     |        |     |         |
| --------------------------------------- | --------------- | --- | ------ | --- | ------- |
| Deployment Cost                         | Deployment Size |     |        |     |         |
| 32287                                   | 191             |     |        |     |         |
| Function Name                           | min             | avg | median | max | # calls |
| foo                                     | 235             | 235 | 235    | 235 | 3       |
