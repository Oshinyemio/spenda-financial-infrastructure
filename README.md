# Spenda: Serverless Financial Analytics Platform

**Spenda** is an enterprise-grade, multi-user financial ecosystem built to automate wealth tracking and budget optimization. By leveraging a fully serverless AWS architecture, the platform provides real-time financial insights while maintaining high scalability and bank-level security standards.

---

## 🏗️ System Architecture
The platform is built on a cloud-native, event-driven architecture designed for cost-efficiency and performance.

- **Infrastructure as Code (IaC):** 100% automated provisioning via **Terraform**, managing VPCs, IAM roles, and serverless resources.
- **Compute:** Modular **AWS Lambda** functions (Python/Node.js) handling transaction processing and financial analytics.
- **Data Layer:** **Amazon DynamoDB** utilizing **Single-Table Design** patterns for optimized retrieval of multi-user financial records.
- **API Management:** **Amazon API Gateway** providing secure RESTful endpoints with integrated Cognito authorization and request throttling.
- **Security & Identity:** **Amazon Cognito** with JWT-based authentication, MFA support, and least-privilege IAM policies.
- **Content Delivery:** **Amazon S3** and **CloudFront** for secure, low-latency global delivery of the analytics dashboard.

---

## 🏦 Financial Engineering Features
Spenda goes beyond simple tracking by implementing complex business logic and third-party integrations:

- **Automated Data Ingestion:** Integrated with the **Plaid API** to synchronize real-time transaction data and account balances.
- **Budgeting Logic:** Custom backend workflows supporting the **65/15/20 budget allocation** and "Savings-First" planning models.
- **Wealth Analytics:** Automated net worth aggregation and cash-flow trend analysis across multiple accounts and credit cards.
- **Scalable Reporting:** Data pipelines optimized for financial reporting and categorical spending breakdowns.

---

## 🛠 Tech Stack
- **Cloud:** AWS (Lambda, API Gateway, DynamoDB, Cognito, S3, CloudFront)
- **IaC:** Terraform
- **Languages:** Python (Backend Logic), JavaScript (Frontend/Integration)
- **Integration:** Plaid API, RESTful APIs
- **Tools:** Git, Postman, AWS CloudWatch

---

## 🔒 Professional Note
This repository serves as a technical showcase of the **Infrastructure as Code (IaC)**, **API Architecture**, and **Cloud Security** patterns implemented in the Spenda platform. 

To maintain the project's path toward commercial release, the proprietary core business logic engines and frontend application code are maintained in a private repository. This public documentation proves the underlying engineering rigor and architectural standards applied to the project.

---

## 📂 Project Structure
```text
spenda-financial-infrastructure/
│
├── terraform/          # IaC modules for Lambda, DynamoDB, Cognito, and IAM
├── api-docs/           # OpenAPI/Swagger specifications for 12 REST resources
├── src/                # Modular Lambda function handlers (Non-proprietary)
├── assets/             # Architectural diagrams and system workflows
└── README.md           # Technical overview
```
---

## 📬 Contact

Ope Oshinyemi – Cloud & Financial Systems Engineer
[LinkedIn](https://linkedin.com/in/oshinyemio) | [oshinyemio@gmail.com](mailto:oshinyemio@gmail.com)

---

## 📜 License

This project is licensed under the MIT License.
