// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SocialMediaEngagement {

    // Struct to hold user information
    struct User {
        uint256 engagementScore; // A simple metric to track engagement
        uint256 rewardPoints;    // Reward points earned
    }

    // Mapping to store user engagement data by address
    mapping(address => User) public users;

    // Event to log engagement actions
    event EngagementUpdated(address indexed user, uint256 engagementScore);

    // Event to log reward distribution
    event RewardGranted(address indexed user, uint256 rewardAmount);

    // Function to update user engagement score (like, comment, share, etc.)
    function updateEngagement(uint256 _engagementScore) public {
        // Update the engagement score
        users[msg.sender].engagementScore += _engagementScore;

        // Emit event for engagement update
        emit EngagementUpdated(msg.sender, users[msg.sender].engagementScore);

        // Calculate reward based on engagement score
        uint256 reward = calculateReward(users[msg.sender].engagementScore);

        // Grant reward points
        users[msg.sender].rewardPoints += reward;

        // Emit reward granted event
        emit RewardGranted(msg.sender, reward);
    }

    // Function to calculate reward based on engagement score
    function calculateReward(uint256 engagementScore) private pure returns (uint256) {
        // A simple reward formula: 1 reward point per 10 engagement score
        return engagementScore / 10;
    }

    // Function to check user data (engagement and rewards)
    function getUserInfo(address _user) public view returns (uint256 engagementScore, uint256 rewardPoints) {
        User memory user = users[_user];
        return (user.engagementScore, user.rewardPoints);
    }

    // Function to withdraw reward (assuming a simple reward system like tokens or Ether)
    function withdrawReward() public {
        uint256 reward = users[msg.sender].rewardPoints;
        require(reward > 0, "No rewards to withdraw");

        // Reset reward points after withdrawal
        users[msg.sender].rewardPoints = 0;

        // In a real contract, you would send tokens or Ether here, e.g.:
        // payable(msg.sender).transfer(reward); // If using Ether

        // For now, we just emit the event
        emit RewardGranted(msg.sender, reward);
    }

    // Fallback function to accept ether if needed (for contract funding)
    receive() external payable {}
}

