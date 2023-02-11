# About

This script can organize newly created AD computer objects into specific OU's based on state abbrevations.

### Assumptions

This script assumes the following of an AD infrastructure:
1. All newly created AD computer objects:
    1. are automatically placed in the default "Computers" container.
    2. need to be moved to a custom "Sites" OU.
2. "Sites" is a root OU and uses the following example heirarchy:
    - Sites
      - Illinois
        - Chicago
          - Computers
        - Aurora
          - Computers
      - Wisconsin
        - Madison
          - Computers
        - Milwaukee
          - Computers

```mermaid
flowchart LR
        subgraph container1[container]
        Computers
        end
        subgraph ou1[ou]
        Sites --> Illinois
            subgraph state1[state]
            Illinois --> Chicago
                subgraph city1[city]
                Chicago --> computer1[Computers]
                end
            Illinois --> Aurora
                subgraph city2[city]
                Aurora --> computer2[Computers]
                end
            end
        Sites --> Wisconsin
            subgraph state2[state]
            Wisconsin --> Madison
                subgraph city3[city]
                Madison --> computer3[Computers]
                end
            Wisconsin --> Milwaukee
                subgraph city4[city]
                Milwaukee --> computer4[Computers]
                end
            end
        end
```
