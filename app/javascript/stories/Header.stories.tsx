import type { Meta, StoryObj } from '@storybook/react';
import Header from '../components/Header';
const meta = {
  title: 'Components/Header',
  component: Header,
  parameters: {
    layout: 'fullscreen',
  },
} satisfies Meta<typeof Header>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    title: 'Seattle Library',
  },
};

export const LoggedIn: Story = {
  args: {
    title: 'Seattle Library',
    user: {
      email: 'user@example.com',
    },
  },
};

export const LoggedOut: Story = {
  args: {
    title: 'Seattle Library',
    user: null,
  },
}; 