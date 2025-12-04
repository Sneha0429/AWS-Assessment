# Task 5 – AWS Architecture Diagram for 10,000 Concurrent Users

## Diagram explanation (5–8 lines)
I designed a multi-AZ, highly scalable architecture that routes public traffic through Route 53 and CloudFront to an internet-facing Application Load Balancer (Sneha_Choudhary_ALB).
The ALB forwards requests to an Auto Scaling Group of EC2 instances running in private subnets across two Availability Zones for fault tolerance.
A managed Aurora (RDS) database with reader replicas stores application data while ElastiCache (Redis) provides caching to reduce DB load and latency.
Static assets are offloaded to S3 and served via CloudFront for lower latency and reduced origin traffic.
CloudWatch, health checks, and auto-scaling policies ensure observability and automatic scaling to handle 10,000 concurrent users.

## Diagram files
- `diagram.drawio` (editable draw.io file)
- `diagram.png` (exported image)
- `diagram.pdf` (optional)

## Notes
- Key scaling components: ALB, ASG, RDS reader replicas, ElastiCache caching, CloudFront for CDN.
- Use RDS Proxy / connection pooling and SSM for instance access in production.
- Destroy any provisioned resources after testing to avoid charges.
