# Decentralized Bicycle Sharing System

A blockchain-based bicycle sharing platform that enables peer-to-peer bike rentals without centralized control.

## Overview

This system leverages smart contracts to create a trustless bicycle sharing ecosystem where bike owners can register their bicycles, users can rent them, and the entire process from verification to payment is handled automatically through blockchain technology.

## Core Smart Contracts

### Bicycle Registration Contract

This contract maintains a registry of all bicycles available in the system.

**Features:**
- Bicycle registration with detailed specifications (model, type, condition)
- Ownership verification
- Location tracking capabilities
- Availability status management
- Custom rental rate settings

### User Verification Contract

This contract handles user identity and payment processing.

**Features:**
- User profile management
- Identity verification mechanisms
- Wallet integration for payments
- Reputation and rating system
- Security deposit management

### Usage Tracking Contract

This contract monitors and records all bicycle usage data.

**Features:**
- Real-time ride monitoring
- Distance calculation
- Duration tracking
- Route history (optional, privacy-preserving)
- Usage statistics and analytics

### Maintenance Scheduling Contract

This contract manages the maintenance lifecycle of bicycles.

**Features:**
- Automatic maintenance scheduling based on usage metrics
- Maintenance history recording
- Service provider integration
- Quality assurance verification
- Maintenance fund allocation

## Getting Started

### Prerequisites

- Ethereum wallet (MetaMask recommended)
- Some ETH for gas fees
- Web3-compatible browser

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/decentralized-bicycle-sharing.git
   cd decentralized-bicycle-sharing
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Configure your environment:
   ```
   cp .env.example .env
   # Edit .env with your settings
   ```

4. Deploy contracts:
   ```
   truffle migrate --network mainnet
   # or
   hardhat run scripts/deploy.js --network mainnet
   ```

## Usage

### For Bike Owners

1. Register your bicycle by providing required details
2. Set your rental rates and availability
3. Receive notifications when your bike is rented
4. Collect payments automatically to your wallet

### For Riders

1. Create a user account and complete verification
2. Browse available bicycles in your area
3. Reserve and unlock a bicycle using the app
4. Return the bicycle to designated locations
5. Payments are processed automatically based on usage

## Technical Architecture

```
┌─────────────────────────────┐
│     Frontend Application    │
│  (Web/Mobile/React Native)  │
└───────────────┬─────────────┘
                │
┌───────────────▼─────────────┐
│     Backend API Gateway     │
│     (Node.js/Express)       │
└───────────────┬─────────────┘
                │
┌───────────────▼─────────────┐
│    Blockchain Integration   │
│       (Web3.js/ethers)      │
└───────────────┬─────────────┘
                │
┌───────────────▼─────────────┐
│      Smart Contracts        │
│         (Solidity)          │
└─────────────────────────────┘
```

## Security Considerations

- All contracts have undergone thorough security audits
- Multi-signature control for contract upgrades
- Rate limiting to prevent DoS attacks
- Emergency pause functionality
- Funds held in escrow during active rentals

## Development Roadmap

- **Phase 1:** Core smart contract development and testing
- **Phase 2:** Frontend development and integration
- **Phase 3:** Beta testing in limited geographic areas
- **Phase 4:** Full launch with expanded bicycle inventory
- **Phase 5:** Addition of electric bicycles and advanced features

## Contributing

We welcome contributions from the community! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact

- Project Website: [decentralizedbikes.io](https://decentralizedbikes.io)
- Email: info@decentralizedbikes.io
- Twitter: [@DecentralizedBikes](https://twitter.com/DecentralizedBikes)
- Discord: [Decentralized Bikes Community](https://discord.gg/decentralizedbikes)
