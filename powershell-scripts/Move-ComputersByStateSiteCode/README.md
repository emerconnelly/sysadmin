# About

[This script](Move-ComputersByStateSiteCode.ps1) can organize newly created AD computer objects into specific OU's based on state abbrevations.

### Assumptions

Assumes the following of an AD infrastructure:
1. All newly created AD computer objects:
    1. are automatically created in the default "Computers" container.
    2. have a 6-character naming prefix, which starts with the two letter US state abbreviation
    3. need to be moved to a custom "Sites" OU.
2. "Sites" is a root OU and uses the following example heirarchy:
```mermaid
flowchart LR
    ad1[(AD Root)]
    ad1 --> computers1[Computers]
        subgraph container1[Container]
        computers1
        end
    ad1 --> Sites
        subgraph ou1[OU]
        Sites --> Illinois
            subgraph state1[State]
            Illinois --> ILCH00
                subgraph city1[City - Chicago]
                ILCH00 --> computer1{{Computers}}
                end
            Illinois --> ILAU00
                subgraph city2[City - Aurora]
                ILAU00 --> computer2{{Computers}}
                end
            end
        Sites --> Wisconsin
            subgraph state2[State]
            Wisconsin --> WIMA00
                subgraph city3[City - Madison]
                WIMA00 --> computer3{{Computers}}
                end
            Wisconsin --> WIMI00
                subgraph city4[City - Milwaukee]
                WIMI00 --> computer4{{Computers}}
                end
            end
        end
```
