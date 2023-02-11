# About

[This script](Move-ComputersByStateSiteCode.ps1) organizes new AD computer objects into specific OU's based on US state abbrevations.

### Assumptions

Assumes the following of an AD infrastructure:
1. All newly created AD computer objects:
    1. are automatically created in the default "Computers" container.
    2. have a 6-character naming prefix, which starts with a two letter US state abbreviation.
    3. need to be placed under a custom "Sites" OU.
2. "Sites" is a root OU and uses the following example heirarchy:
```mermaid
flowchart LR
    ad1[(AD Root)]
    ad1 --> computers1[CN=Computers]
        subgraph container1[Container]
        computers1
        end
    ad1 --> sites(OU=Sites)
        subgraph states1[States]
        sites --> illinois(OU=Illinois)
            subgraph state1[State - Illinois]
            illinois --> chicago(OU=ILCH00)
                subgraph city1[City - Chicago]
                chicago --> computer1{{OU=Computers}}
                end
            illinois --> aurora(OU=ILAU00)
                subgraph city2[City - Aurora]
                aurora --> computer2{{OU=Computers}}
                end
            end
        sites --> wisconsin(OU=Wisconsin)
            subgraph state2[State - Wisconsin]
            wisconsin --> madison(OU=WIMA00)
                subgraph city3[City - Madison]
                madison --> computer3{{OU=Computers}}
                end
            wisconsin --> milwaukee(OU=WIMI00)
                subgraph city4[City - Milwaukee]
                milwaukee --> computer4{{OU=Computers}}
                end
            end
        end
```
