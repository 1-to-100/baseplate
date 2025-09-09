# Frontend Component Development Guide

This guide explains how to create and structure frontend components in the stock-app project.

## Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Component Structure](#component-structure)
- [Creating New Components](#creating-new-components)
- [Component Patterns](#component-patterns)
- [Styling Guidelines](#styling-guidelines)
- [Testing with Storybook](#testing-with-storybook)
- [Best Practices](#best-practices)
- [Examples](#examples)

## Project Overview

The stock-app is a Next.js 15 application built with TypeScript, using Material-UI Joy as the primary component library. The project follows a modular architecture with clear separation of concerns.

## Tech Stack

- **Framework**: Next.js 15 with App Router
- **Language**: TypeScript
- **UI Library**: Material-UI Joy (@mui/joy)
- **Icons**: Phosphor Icons (@phosphor-icons/react)
- **State Management**: React Query (@tanstack/react-query)
- **Forms**: React Hook Form with Zod validation
- **Styling**: Emotion (CSS-in-JS)
- **Testing**: Storybook
- **Package Manager**: pnpm

## Component Structure

The project follows a well-organized component structure:

```
src/
├── components/
│   ├── core/           # Reusable core components
│   ├── dashboard/      # Dashboard-specific components
│   ├── auth/           # Authentication components
│   └── marketing/      # Marketing page components
├── hooks/              # Custom React hooks
├── lib/                # Utility functions and configurations
├── types/              # TypeScript type definitions
└── stories/            # Storybook stories
```

## Creating New Components

### 1. Choose the Right Location

- **Core components** (`src/components/core/`): Reusable components used across the app
- **Dashboard components** (`src/components/dashboard/`): Components specific to dashboard functionality
- **Auth components** (`src/components/auth/`): Authentication-related components
- **Marketing components** (`src/components/marketing/`): Marketing page components

### 2. Component File Structure

Create your component with the following structure:

```typescript
// src/components/core/MyComponent.tsx
import * as React from 'react';
import { ComponentProps } from '@mui/joy/ComponentName';

export interface MyComponentProps extends ComponentProps {
  // Define your props here
  title: string;
  variant?: 'primary' | 'secondary';
  onAction?: () => void;
}

export function MyComponent({ 
  title, 
  variant = 'primary', 
  onAction,
  ...props 
}: MyComponentProps): React.JSX.Element {
  return (
    <div>
      {/* Your component JSX */}
    </div>
  );
}
```

### 3. Create Storybook Story

Create a corresponding Storybook story:

```typescript
// src/stories/MyComponent.stories.tsx
import type { Meta, StoryObj } from '@storybook/nextjs';
import React from 'react';
import { fn } from 'storybook/test';
import { MyComponent } from './MyComponent';

const meta = {
  title: 'Components/MyComponent',
  component: MyComponent,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['primary', 'secondary'],
    },
  },
  args: { onAction: fn() },
} satisfies Meta<typeof MyComponent>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    title: 'Primary Component',
    variant: 'primary',
  },
};

export const Secondary: Story = {
  args: {
    title: 'Secondary Component',
    variant: 'secondary',
  },
};
```

## Component Patterns

### 1. Basic Component Pattern

```typescript
import * as React from 'react';
import { ComponentProps } from '@mui/joy/ComponentName';

export interface MyComponentProps extends ComponentProps {
  // Props definition
}

export function MyComponent({ ...props }: MyComponentProps): React.JSX.Element {
  return (
    // Component JSX
  );
}
```

### 2. Dashboard Component Pattern

```typescript
'use client';

import * as React from 'react';
import { useSelection } from '@/hooks/use-selection';
import { DataTable } from '@/components/core/data-table';

export interface MyTableProps {
  rows: MyDataType[];
}

export function MyTable({ rows }: MyTableProps): React.JSX.Element {
  const rowIds = React.useMemo(() => rows.map((row) => row.id), [rows]);
  const selection = useSelection(rowIds);

  return (
    <DataTable
      // Table configuration
    />
  );
}
```

### 3. Form Component Pattern

```typescript
import * as React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  // Form validation schema
});

export interface MyFormProps {
  onSubmit: (data: FormData) => void;
}

export function MyForm({ onSubmit }: MyFormProps): React.JSX.Element {
  const { control, handleSubmit } = useForm({
    resolver: zodResolver(schema),
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* Form fields */}
    </form>
  );
}
```

## Styling Guidelines

### 1. Use Material-UI Joy Components

Prefer Joy UI components over custom HTML elements:

```typescript
// ✅ Good
import { Button, Card, Typography } from '@mui/joy';

// ❌ Avoid
<button>Click me</button>
```

### 2. Custom Styling with sx Prop

Use the `sx` prop for custom styling:

```typescript
<Button
  sx={{
    background: 'linear-gradient(120deg, #282490 0%, #3F4DCF 100%)',
    '&:hover': {
      background: 'linear-gradient(120deg, #1E1A6F 0%, #3439B0 100%)',
    },
  }}
>
  Click me
</Button>
```

### 3. CSS Variables

Use CSS variables for consistent theming:

```typescript
sx={{
  color: 'var(--joy-palette-text-primary)',
  backgroundColor: 'var(--joy-palette-background-mainBg)',
}}
```

### 4. Responsive Design

Use responsive breakpoints:

```typescript
sx={{
  display: { xs: 'none', lg: 'block' },
  width: { xs: '100%', md: '50%' },
}}
```

## Testing with Storybook

### 1. Run Storybook

```bash
pnpm storybook
```

### 2. Create Comprehensive Stories

Create stories for different component states:

```typescript
export const AllVariants: Story = {
  args: {
    label: 'Button',
  },
  render: () => (
    <div style={{ display: 'flex', gap: '12px', flexWrap: 'wrap' }}>
      <Button label="Primary" primary />
      <Button label="Secondary" variant="outlined" />
      <Button label="Plain" variant="plain" />
    </div>
  ),
};
```

### 3. Interactive Controls

Use Storybook controls for testing:

```typescript
argTypes: {
  variant: {
    control: { type: 'select' },
    options: ['primary', 'secondary', 'danger'],
  },
  size: {
    control: { type: 'select' },
    options: ['small', 'medium', 'large'],
  },
},
```

## Best Practices

### 1. TypeScript

- Always define proper interfaces for props
- Use `React.JSX.Element` as return type
- Extend existing component props when possible

### 2. Component Design

- Keep components focused and single-purpose
- Use composition over inheritance
- Make components reusable and configurable

### 3. Performance

- Use `React.useMemo` for expensive calculations
- Use `React.useCallback` for event handlers passed to children
- Implement proper key props for lists

### 4. Accessibility

- Use semantic HTML elements
- Provide proper ARIA labels
- Ensure keyboard navigation works

### 5. Code Organization

- Group related components in folders
- Use index files for clean imports
- Follow consistent naming conventions

## Examples

### Example 1: Simple Button Component

```typescript
// src/components/core/CustomButton.tsx
import * as React from 'react';
import { Button as JoyButton, ButtonProps as JoyButtonProps } from '@mui/joy';

export interface CustomButtonProps extends Omit<JoyButtonProps, 'variant' | 'color'> {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  label: string;
}

export function CustomButton({ 
  variant = 'primary', 
  size = 'medium', 
  label,
  ...props 
}: CustomButtonProps): React.JSX.Element {
  return (
    <JoyButton
      variant="solid"
      color={variant === 'primary' ? 'primary' : variant === 'danger' ? 'danger' : 'neutral'}
      size={size === 'large' ? 'lg' : size === 'small' ? 'sm' : 'md'}
      {...props}
    >
      {label}
    </JoyButton>
  );
}
```

### Example 2: Data Table Component

```typescript
// src/components/dashboard/MyDataTable.tsx
'use client';

import * as React from 'react';
import { DataTable } from '@/components/core/data-table';
import { useSelection } from '@/hooks/use-selection';
import type { ColumnDef } from '@/components/core/data-table';

export interface MyData {
  id: string;
  name: string;
  email: string;
  status: 'active' | 'inactive';
}

const columns: ColumnDef<MyData>[] = [
  { field: 'id', name: 'ID', width: '100px' },
  { field: 'name', name: 'Name', width: '200px' },
  { field: 'email', name: 'Email', width: '250px' },
  { field: 'status', name: 'Status', width: '100px' },
];

export interface MyDataTableProps {
  rows: MyData[];
}

export function MyDataTable({ rows }: MyDataTableProps): React.JSX.Element {
  const rowIds = React.useMemo(() => rows.map((row) => row.id), [rows]);
  const selection = useSelection(rowIds);

  return (
    <DataTable
      columns={columns}
      rows={rows}
      selectable
      selected={selection.selected}
      onSelectAll={selection.selectAll}
      onDeselectAll={selection.deselectAll}
      onSelectOne={(_, row) => selection.selectOne(row.id)}
      onDeselectOne={(_, row) => selection.deselectOne(row.id)}
    />
  );
}
```

### Example 3: Form Component

```typescript
// src/components/forms/UserForm.tsx
import * as React from 'react';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Button, Input, FormControl, FormLabel } from '@mui/joy';

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email address'),
});

type FormData = z.infer<typeof schema>;

export interface UserFormProps {
  onSubmit: (data: FormData) => void;
  initialData?: Partial<FormData>;
}

export function UserForm({ onSubmit, initialData }: UserFormProps): React.JSX.Element {
  const { control, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: initialData,
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <FormControl error={!!errors.name}>
        <FormLabel>Name</FormLabel>
        <Controller
          name="name"
          control={control}
          render={({ field }) => (
            <Input {...field} placeholder="Enter name" />
          )}
        />
      </FormControl>
      
      <FormControl error={!!errors.email}>
        <FormLabel>Email</FormLabel>
        <Controller
          name="email"
          control={control}
          render={({ field }) => (
            <Input {...field} type="email" placeholder="Enter email" />
          )}
        />
      </FormControl>
      
      <Button type="submit">Submit</Button>
    </form>
  );
}
```

## Development Workflow

1. **Plan your component**: Define props, behavior, and styling requirements
2. **Create the component file**: Follow the established patterns
3. **Write TypeScript interfaces**: Define clear prop types
4. **Implement the component**: Use Joy UI components and proper styling
5. **Create Storybook stories**: Test different states and configurations
6. **Test in Storybook**: Verify component behavior and appearance
7. **Integrate into the app**: Use the component in your pages/features
8. **Document usage**: Add JSDoc comments for complex props

## Resources

- [Material-UI Joy Documentation](https://mui.com/joy-ui/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Storybook Documentation](https://storybook.js.org/docs)
- [React Hook Form Documentation](https://react-hook-form.com/)
- [Zod Documentation](https://zod.dev/)

---

This guide should help you create consistent, maintainable, and well-tested components in the stock-app project. For questions or clarifications, refer to existing components in the codebase or consult the team.
