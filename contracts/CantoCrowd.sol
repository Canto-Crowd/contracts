// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Cantocrowd is ReentrancyGuard {
    // @dev Define project structure

    struct Project {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donation;
    }

    mapping(uint256 => Project) public projects;

    uint256 public numberOfProjects = 0;

    function createProject(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Project storage project = projects[numberOfProjects];

        require(
            project.deadline < block.timestamp,
            "Deadline need be a date in the future"
        );

        project.owner = _owner;
        project.title = _title;
        project.description = _description;
        project.target = _target;
        project.deadline = _deadline;
        project.amountCollected = 0;
        project.image = _image;

        numberOfProjects++;

        return numberOfProjects - 1;
    }

    function donateProject(uint256 _id) public payable {
        uint256 amount = msg.value;

        Project storage project = projects[_id];

        project.donators.push(msg.sender);
        project.donation.push(amount);

        (bool sent, ) = payable(project.owner).call{value: amount}("");

        if (sent) {
            project.amountCollected = project.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id)
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        return (projects[_id].donators, projects[_id].donation);
    }

    function getProjects() public view returns (Project[] memory) {
        Project[] memory allProjects = new Project[](numberOfProjects);

        for (uint256 i = 0; i < numberOfProjects; i++) {
            Project storage item = projects[i];

            allProjects[i] = item;
        }

        return allProjects;
    }
}
