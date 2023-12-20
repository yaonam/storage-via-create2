# Test Storage Patterns

This repo compares the deployment and call forwarding costs of three types of proxies: calldata, immutable storage, and bytecode. The proxy address must be computable and proxies must not read from storage.

## Gas Report

| src/Counter.sol:CalldataProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 56905                                  | 316             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3489            | 3489 | 3489   | 3489 | 1       |

| src/Counter.sol:StorageProxy contract |                 |      |        |      |         |
| ------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                       | Deployment Size |      |        |      |         |
| 79950                                 | 660             |      |        |      |         |
| Function Name                         | min             | avg  | median | max  | # calls |
| forward                               | 3254            | 3254 | 3254   | 3254 | 1       |

| src/Counter.sol:BytecodeProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 80509                                  | 663             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3254            | 3254 | 3254   | 3254 | 1       |

| src/Counter.sol:Caller contract |                 |        |        |        |         |
| ------------------------------- | --------------- | ------ | ------ | ------ | ------- |
| Deployment Cost                 | Deployment Size |        |        |        |         |
| 571206                          | 2885            |        |        |        |         |
| Function Name                   | min             | avg    | median | max    | # calls |
| callBytecodeProxy               | 3897            | 3897   | 3897   | 3897   | 1       |
| callCalldataProxy               | 4462            | 4462   | 4462   | 4462   | 1       |
| callStorageProxy                | 3919            | 3919   | 3919   | 3919   | 1       |
| deployBytecodeProxy             | 159773          | 159773 | 159773 | 159773 | 1       |
| deployCalldataProxy             | 133819          | 133819 | 133819 | 133819 | 1       |
| deployStorageProxy              | 137144          | 137144 | 137144 | 137144 | 1       |
| getImplAndCred                  | 341             | 341    | 341    | 341    | 1       |

| src/Counter.sol:Implementation contract |                 |     |        |     |         |
| --------------------------------------- | --------------- | --- | ------ | --- | ------- |
| Deployment Cost                         | Deployment Size |     |        |     |         |
| 32287                                   | 191             |     |        |     |         |
| Function Name                           | min             | avg | median | max | # calls |
| foo                                     | 235             | 235 | 235    | 235 | 3       |
