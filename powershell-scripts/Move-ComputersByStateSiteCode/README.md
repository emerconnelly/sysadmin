# About

[This script](Move-ComputersByStateSiteCode.ps1) can organize newly created AD computer objects into specific OU's based on state abbrevations.

### Assumptions

Assumes the following of an AD infrastructure:
1. All newly created AD computer objects:
    1. are automatically placed in the default "Computers" container.
    2. need to be moved to a custom "Sites" OU.
    3. have a 6-character naming prefix, which starts with the two letter US state abbreviation
2. "Sites" is a root OU and uses the following example heirarchy:
    - 
```mermaid
flowchart LR
    ad1[(AD Root)]
    ad1 --> computers1[Computers]
        subgraph container1[container]
        computers1
        end
    ad1 --> Sites
        subgraph ou1[ou]
        Sites --> Illinois
            subgraph state1[state]
            Illinois --> ILCH00
                subgraph city1[city: Chicago]
                ILCH00 --> computer1[Computers]
                end
            Illinois --> ILAU00
                subgraph city2[city: Aurora]
                ILAU00 --> computer2[Computers]
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
