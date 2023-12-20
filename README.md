# Test Storage Patterns

This repo compares the deployment and call forwarding costs of three types of proxies: calldata, immutable storage, and bytecode. The proxy address must be computable and proxies must not read from storage.

## Gas Report

| src/Counter.sol:Caller contract |                 |        |        |        |         |
| ------------------------------- | --------------- | ------ | ------ | ------ | ------- |
| Deployment Cost                 | Deployment Size |        |        |        |         |
| 745301                          | 3708            |        |        |        |         |
| Function Name                   | min             | avg    | median | max    | # calls |
| bytecodeProxy                   | 359             | 359    | 359    | 359    | 1       |
| callBytecodeProxy               | 3986            | 3986   | 3986   | 3986   | 1       |
| callCalldataProxy               | 4418            | 4418   | 4418   | 4418   | 1       |
| callCloneProxy                  | 3546            | 3546   | 3546   | 3546   | 1       |
| callImmutableProxy              | 3942            | 3942   | 3942   | 3942   | 1       |
| calldataProxy                   | 404             | 404    | 404    | 404    | 1       |
| cloneProxy                      | 381             | 381    | 381    | 381    | 1       |
| computeBytecodeProxyAddress     | 1039            | 1039   | 1039   | 1039   | 1       |
| computeCalldataProxyAddress     | 975             | 975    | 975    | 975    | 1       |
| computeCloneProxyAddress        | 846             | 846    | 846    | 846    | 1       |
| computeImmutableProxyAddress    | 2956            | 2956   | 2956   | 2956   | 1       |
| deployBytecodeProxy             | 154845          | 154845 | 154845 | 154845 | 1       |
| deployCalldataProxy             | 113648          | 113648 | 113648 | 113648 | 1       |
| deployCloneProxy                | 65863           | 65863  | 65863  | 65863  | 1       |
| deployImmutableProxy            | 109906          | 109906 | 109906 | 109906 | 1       |
| getImplAndCred                  | 466             | 466    | 466    | 466    | 1       |
| immutableProxy                  | 382             | 382    | 382    | 382    | 1       |

| src/Counter.sol:CalldataProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 56905                                  | 316             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3489            | 3489 | 3489   | 3489 | 1       |

| src/Counter.sol:ImmutableProxy contract |                 |      |        |      |         |
| --------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                         | Deployment Size |      |        |      |         |
| 52896                                   | 513             |      |        |      |         |
| Function Name                           | min             | avg  | median | max  | # calls |
| forward                                 | 3232            | 3232 | 3232   | 3232 | 1       |

| src/Counter.sol:BytecodeProxy contract |                 |      |        |      |         |
| -------------------------------------- | --------------- | ---- | ------ | ---- | ------- |
| Deployment Cost                        | Deployment Size |      |        |      |         |
| 53580                                  | 516             |      |        |      |         |
| Function Name                          | min             | avg  | median | max  | # calls |
| forward                                | 3232            | 3232 | 3232   | 3232 | 1       |

| src/Counter.sol:Implementation contract |                 |     |        |     |         |
| --------------------------------------- | --------------- | --- | ------ | --- | ------- |
| Deployment Cost                         | Deployment Size |     |        |     |         |
| 32287                                   | 191             |     |        |     |         |
| Function Name                           | min             | avg | median | max | # calls |
| foo                                     | 235             | 235 | 235    | 235 | 4       |
