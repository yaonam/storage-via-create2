# Test Storage Patterns

This repo compares the deployment and call forwarding costs of three types of proxies: calldata, immutable storage, and bytecode. The proxy address must be computable and proxies must not read from storage.

## Gas Report

| src/Counter.sol:Caller contract |                 |        |        |        |         |
| ------------------------------- | --------------- | ------ | ------ | ------ | ------- |
| Deployment Cost                 | Deployment Size |        |        |        |         |
| 690842                          | 4543            |        |        |        |         |
| Function Name                   | min             | avg    | median | max    | # calls |
| callBytecodeProxy               | 3897            | 3897   | 3897   | 3897   | 1       |
| callCalldataProxy               | 4743            | 4743   | 4743   | 4743   | 1       |
| callCloneProxy                  | 4085            | 4085   | 4085   | 4085   | 1       |
| callImmutableProxy              | 6233            | 6233   | 6233   | 6233   | 1       |
| computeBytecodeProxyAddress     | 551             | 551    | 551    | 551    | 1       |
| computeCalldataProxyAddress     | 594             | 594    | 594    | 594    | 1       |
| computeCloneProxyAddress        | 724             | 724    | 724    | 724    | 1       |
| computeImmutableProxyAddress    | 2789            | 2789   | 2789   | 2789   | 1       |
| deployBytecodeProxy             | 125266          | 125266 | 125266 | 125266 | 1       |
| deployCalldataProxy             | 89017           | 89017  | 89017  | 89017  | 1       |
| deployCloneProxy                | 41661           | 41661  | 41661  | 41661  | 1       |
| deployImmutableProxy            | 80396           | 80396  | 80396  | 80396  | 1       |
| getImplAndCred                  | 444             | 444    | 444    | 444    | 1       |

| src/Counter.sol:BytecodeProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 48152                                  | 487             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| fallback                               | 3192            | 3192 | 3192   | 3192 | 1       |

| src/Counter.sol:CalldataProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 56505                                  | 314             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3557            | 3557 | 3557   | 3557 | 1       |

| src/Counter.sol:ImmutableProxy contract |                 |      |        |      |         |
| --------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                         | Deployment Size |      |        |      |         |
| 47490                                   | 484             |      |        |      |         |
| Function Name                           | min             | avg  | median | max  | # calls |
| fallback                                | 3192            | 3192 | 3192   | 3192 | 1       |

| src/Counter.sol:Implementation contract |                 |     |        |     |         |
| --------------------------------------- | --------------- | --- | ------ | --- | ------- |
| Deployment Cost                         | Deployment Size |     |        |     |         |
| 45521                                   | 394             |     |        |     |         |
| Function Name                           | min             | avg | median | max | # calls |
| foo                                     | 306             | 306 | 306    | 306 | 4       |
